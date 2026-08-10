# Widget Loading

Bootstrap begins in `runtime.lua`.

## Discovery

The Swift host resolves the configured manual widgets directory and the fixed managed activation directory. It passes the manual path as a runtime argument and the managed path through an internal environment variable. The two roots deliberately use different discovery rules.

Manual discovery recursively loads regular `.lua` files below `widgets_dir`, excluding `shared/`:

```text
<widgets_dir>/**/*.lua
```

Managed discovery does not recurse. `api.lua` lists only top-level symbolic links below
`~/.local/share/easybar/packages/active/`, skips `active/shared/`, resolves each widget link to its
committed `store/<name>/<version>/<entrypoint>` target, and loads that one file. Declared library
exports remain available only through `require(...)` below `active/shared/`.

The Lua runtime never recursively scans `store/`, so sibling Lua files in an installed package are
not executed merely because the package was installed.

## Flow

1. Swift resolves `widgets_dir` and the managed activation path, then launches `EasyBarLuaRuntime`
2. the runtime agent forwards `widgets_dir` to `runtime.lua`, while the managed path is inherited through the environment
3. `api.lua` lists and resolves top-level managed widget activation symlinks
4. `loader.lua` transactionally executes those resolved package entrypoints
5. `api.lua` recursively discovers and sorts manual widget files
6. `loader.lua` transactionally executes the manual files

Managed startup adds only the declared export namespace to Lua's module search path:

```text
<managed-active>/shared/?.lua
<managed-active>/shared/?/init.lua
```

Manual startup then prepends the configured manual root and its shared modules:

```text
<widgets_dir>/?.lua
<widgets_dir>/?/init.lua
<widgets_dir>/shared/?.lua
<widgets_dir>/shared/?/init.lua
```

The manual root is configured after managed exports and therefore has precedence for manual widget
startup, while managed exports remain available as a fallback.

Inside `loader.lua`:

1. configure the applicable module paths for the managed or manual root
2. create an isolated environment for each entrypoint or discovered manual file
3. inject a scoped `easybar` API with the correct source directory and asset root
4. execute the file transactionally

## Managed activation

The package manager keeps each committed package directly below:

```text
~/.local/share/easybar/packages/store/<name>/<version>/
├── package.toml
└── ...installed package files...
```

There is no generated package projection. For a widget package, `active/<name>` is a relative
symbolic link directly to the entrypoint declared in that committed version. Declared exports are
symbolic links below `active/shared/` that point directly to their declared package files.

Managed discovery considers only those top-level widget activation links and never recursively
walks a committed package directory. The activation link is resolved before loading so
`easybar.asset(...)` uses the actual package location rather than the `active/` directory.

The package manager, not the Lua runtime, owns version switching and retention. See
[Widget Packages](../../runtime/widget-packages.md) for staging, rollback, active symlinks, and the
three-version retention policy.

## Source identities

Managed package logs and command diagnostics use the package activation name, independent of the
entrypoint's internal path:

```text
active/inbox-github -> store/inbox-github/0.5.1/widget.lua -> inbox-github
```

Manual widgets continue to use their path relative to `widgets_dir`, without the `.lua` extension:

```text
brew/widget.lua         -> brew/widget
inbox/github/widget.lua -> inbox/github/widget
```

This keeps installed package identities stable while preserving directory context for manually
managed widgets.

## Asset roots

`easybar.asset("icon.svg")` resolves from the current entrypoint's directory. For manual widgets, `easybar.asset("@/assets/icon.svg")` resolves from the configured widgets root. For managed packages, `@/` resolves from that package's committed version root. Both forms reject absolute paths and attempts to escape their selected root.

## Important details

- package entrypoints below the managed activation root load first
- managed discovery loads only top-level widget activation symlinks and excludes `shared/`
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
