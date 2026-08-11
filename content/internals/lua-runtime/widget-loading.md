# Widget Loading

Lua startup loads two kinds of widget source with deliberately different discovery rules:

- package-managed widget entrypoints selected from the active frontend package store;
- manually managed Lua files below that frontend's configured `[app].widgets_dir`.

The package manager decides _which package files are active_. The Lua runtime decides _how one active
entrypoint or manual file is executed_.

## Frontend roots

EasyBar and EasyBar Native use the same loading algorithm with different roots:

```text
EasyBar
  manual:   ~/.config/easybar/widgets
  managed:  ~/.local/share/easybar/packages/active

EasyBar Native
  manual:   ~/.config/easybar-native/widgets
  managed:  ~/.local/share/easybar-native/packages/active
```

Explicit config or bootstrap overrides can change those defaults.

## Managed widgets

The Swift host passes the selected managed activation directory through an internal environment
value. `api.lua` lists only top-level symbolic links below `active/`, skips `active/shared/`, resolves
each widget link to the committed entrypoint, and loads exactly that file.

Declared package exports are available only through:

```text
<managed-active>/shared/?.lua
<managed-active>/shared/?/init.lua
```

The runtime never recursively scans package version directories. See [Package Store Internals](../package-store.md).

## Manual widgets

The configured `widgets_dir` is passed as a runtime argument. `api.lua` recursively discovers every
regular `.lua` file below it except files under `shared/`:

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

Manual module paths are configured after managed exports, so manual modules take precedence while
managed exports remain available as a fallback.

## Execution flow

1. Swift resolves the selected frontend's manual and managed roots.
2. `EasyBarLuaRuntime` starts `runtime.lua` with both roots available.
3. `api.lua` resolves managed activation links.
4. `loader.lua` transactionally executes each managed entrypoint.
5. `api.lua` recursively discovers and sorts manual widget files.
6. `loader.lua` transactionally executes each manual file.

For each source, the loader creates a file-local environment that falls back to `_G`, injects a
widget-scoped `easybar` value, records source and asset roots, and rolls back that source's registry
changes if top-level execution fails.

## Source identities

Managed diagnostics use the package activation name regardless of the internal entrypoint path.
Manual diagnostics use the path relative to the selected `widgets_dir`, without `.lua`.

## Assets and modules

`easybar.asset("icon.svg")` resolves beside the current entrypoint. `easybar.asset("@/assets/icon.svg")`
resolves from the relevant manual widget root or committed managed package root.

Successful `require(...)` calls use Lua's process-wide `package.loaded` cache. A full runtime restart
clears that cache because the complete Lua process is replaced.

## Trust model

Widget files are trusted local scripts. Per-file environments organize state but are not a security
sandbox.
