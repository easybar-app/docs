# Widget Loading

Bootstrap begins in `runtime.lua`.

## Discovery

The Swift host resolves the configured manual widgets directory and the fixed managed activation directory. It passes the manual path as a runtime argument and the managed path through an internal environment variable. Swift does not enumerate files or assign meaning to filenames. After startup, `api.lua` recursively discovers regular files with a `.lua` extension in each root. Extension matching is case-insensitive:

```text
~/.local/share/easybar/packages/active/**/*.lua
<widgets_dir>/**/*.lua
```

Both roots prune `shared/`, so reusable modules load only through `require(...)`. Managed package
discovery follows the symlinks below `active/` and also prunes each committed version's `.easybar/`
metadata directory. Manual widget discovery does not follow package activation symlinks and gives no
special meaning to a manual `.easybar/` directory.

The managed activation tree contains widget symlinks and declared export symlinks. Complete package
source remains below `store/<name>/<version>/.easybar/source/` and is not scanned.

## Flow

1. Swift resolves `widgets_dir` and the managed activation path, then launches `EasyBarLuaRuntime`
2. the runtime agent forwards `widgets_dir` to `runtime.lua`, while the managed path is inherited through the environment
3. `api.lua` follows managed activation symlinks, discovers package entrypoints, and sorts them
4. `loader.lua` transactionally executes the managed entrypoints
5. `api.lua` discovers and sorts manual widget files
6. `loader.lua` transactionally executes the manual files

For each root, `loader.lua` prepends these paths to Lua's standard module search path in this order:

```text
<widgets_dir>/?.lua
<widgets_dir>/?/init.lua
<widgets_dir>/shared/?.lua
<widgets_dir>/shared/?/init.lua
```

Root-local modules take precedence over generic shared modules. The managed root is configured
first. The manual root is configured afterward and therefore has precedence for manual widget
startup, while managed exports remain available as a fallback.

Inside `loader.lua`:

1. configure root and shared module paths
2. create an isolated environment for each discovered file
3. inject a scoped `easybar` API with both the source directory and widgets root
4. execute the file transactionally

## Managed activation

The package manager keeps committed versions below:

```text
~/.local/share/easybar/packages/store/<name>/<version>/
```

For a widget package, `active/<name>` is a relative symlink to its committed version. Declared
exports are symlinks below `active/shared/` that point into the committed version's
`.easybar/source/` tree. Managed discovery follows the widget symlink but prunes both `shared/` and
`.easybar/`, so only the package entrypoint projection is executed as widget code.

The package manager, not the Lua runtime, owns version switching and retention. See
[Widget Packages](../../runtime/widget-packages.md) for staging, rollback, active symlinks, and the
three-version retention policy.

## Source identities

Logs and command diagnostics use the file's path relative to the root from which it was loaded, without the `.lua` extension:

```text
brew/widget.lua         -> brew/widget
inbox/github/widget.lua -> inbox/github/widget
```

This rule is generic, preserves directory context, and does not assign special meaning to `widget.lua`.

## Asset roots

`easybar.asset("icon.svg")` resolves from the current file's directory. `easybar.asset("@/assets/icon.svg")` resolves from the configured widgets root. Both forms reject absolute paths and attempts to escape their selected root.

## Important details

- package entrypoints below the managed activation root load first
- managed discovery follows activation symlinks and excludes `shared/` plus package `.easybar/` metadata
- every regular file below `widgets_dir` with a `.lua` extension is executed except files below `shared/`
- each file receives isolated widget defaults and local variables
- all files share one runtime registry
- reusable modules below `shared/` load through `require(...)` and are not directly discovered
- required modules use Lua's process-wide `package.loaded` cache
- reload is a full reset
- widget environments fall back to `_G`, so isolation is about local state, not security

Keep module top levels declarative and avoid starting timers, commands, or subscriptions outside an explicit function called by a widget.

## Trust model

EasyBar widget files are trusted local scripts. The per-file environment prevents ordinary local variables and defaults from leaking into other files, but it falls back to `_G`. This is not a sandbox; do not treat third-party Lua files as untrusted code.

## Public widget API shape

Lua widget authors use node handles. `easybar.add(...)` creates one node and returns its handle:

```lua
local clock = easybar.add(easybar.kind.item, "clock", {
    position = "right",
    order = 10,
    label = os.date("%H:%M"),
})
```

The returned handle owns node operations:

- `node.id`
- `node.name`
- `node:set(props)`
- `node:get()`
- `node:remove()`
- `node:subscribe(events, handler)`

Internally, `api.lua` delegates those operations to the registry and subscription modules by id. The id-based functions remain internal implementation details.
