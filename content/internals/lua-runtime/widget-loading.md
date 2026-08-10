# Widget Loading

Lua startup loads two kinds of widget source with deliberately different discovery rules:

- package-managed widget entrypoints selected by the package manager;
- manually managed Lua files below `[app].widgets_dir`.

The package manager decides _what package file is active_. The Lua runtime decides _how an active
entrypoint or manual file is executed_.

## Managed widgets

The Swift host passes the fixed managed activation directory through an internal environment value.
`api.lua` lists only top-level symbolic links below:

```text
~/.local/share/easybar/packages/active/
```

It skips `active/shared/`, resolves each widget link to the real committed entrypoint, and loads that
one file. Managed discovery does not recurse into package directories or the versioned store.

Declared package exports are available only through the managed module namespace:

```text
<managed-active>/shared/?.lua
<managed-active>/shared/?/init.lua
```

The exact store layout, activation links, install transactions, and version retention belong in
[Package Store Internals](../package-store.md).

## Manual widgets

The configured `widgets_dir` is passed as a runtime argument. `api.lua` recursively discovers every
regular `.lua` file below that directory except files below `shared/`:

```text
<widgets_dir>/**/*.lua
```

Manual module lookup uses:

```text
<widgets_dir>/?.lua
<widgets_dir>/?/init.lua
<widgets_dir>/shared/?.lua
<widgets_dir>/shared/?/init.lua
```

The manual paths are configured after managed exports, so manual modules take precedence while
managed exports remain available as a fallback.

## Execution flow

1. Swift resolves `widgets_dir` and the managed activation root.
2. `EasyBarLuaRuntime` starts `runtime.lua` with both roots available.
3. `api.lua` lists and resolves managed widget activation links.
4. `loader.lua` transactionally executes each managed entrypoint.
5. `api.lua` recursively discovers and sorts manual widget files.
6. `loader.lua` transactionally executes each manual file.

For every loaded widget source, `loader.lua`:

1. creates a per-file environment that falls back to `_G`;
2. injects a widget-scoped `easybar` value;
3. records the source identity and asset roots;
4. executes the file transactionally.

A top-level failure rolls back that file's registry changes and does not turn the per-file
environment into a sandbox.

## Source identities

Managed package diagnostics use the activation package name regardless of the entrypoint's internal
path:

```text
active/inbox-github -> store/inbox-github/0.5.1/widget.lua -> inbox-github
```

Manual widgets use their path relative to `widgets_dir`, without `.lua`:

```text
clock.lua               -> clock
inbox/github/widget.lua -> inbox/github/widget
```

This keeps installed package identities stable while retaining useful directory context for manual
widgets.

## Assets

`easybar.asset("icon.svg")` resolves from the current entrypoint directory.

For a manual widget, `easybar.asset("@/assets/icon.svg")` resolves from the configured
`widgets_dir`. For a managed package, `@/` resolves from the committed package root.

Managed activation links are resolved before the scoped API is created, so file-relative assets use
the real package location rather than the `active/` directory. Both forms reject absolute paths and
attempts to escape the selected root.

## Module lifetime

Reusable manual modules and package exports load through normal `require(...)`. Successful module
loads use Lua's process-wide `package.loaded` cache, so mutable module state is shared by every
consumer in the same runtime session.

A full runtime restart clears the process and therefore clears the module cache.

## Trust model

Widget files are trusted local scripts. Per-file environments keep ordinary local variables and
widget defaults separate, but they fall back to `_G`. Do not treat package or manual widget code as
sandboxed content.
