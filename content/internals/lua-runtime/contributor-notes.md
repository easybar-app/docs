# Contributor Notes

Use this page when changing the Lua runtime or public Lua API.

## Where to change what

### Widget API

- `api.lua`
- `easybar_api.base.lua`
- `easybar_api.events.lua`
- `easybar_api.lua`
- `content/lua/*` in the `easybar-app/docs` repository

`easybar_api.base.lua` is the hand-edited source stub.
`easybar_api.events.lua` is generated from the event catalog.
`easybar_api.lua` is the combined generated artifact that EasyBar installs for LuaLS/editor support.

### Driver events

- `event_tokens.lua`
- `easybar_api.events.lua`
- `easybar_api.lua`
- Swift event sources

### Event payloads

- `EventHub.swift`
- `EventTypes.swift`
- `events.lua`

### Rendering

- `render.lua`
- `WidgetNodeState.swift`

### Process and runtime

- `RuntimeCoordinator.swift`
- `WidgetEngine.swift`
- `LuaProcessController.swift`
- `LuaTransport.swift`

## Formatting

Install StyLua before running the repository formatting checks:

```bash
brew install stylua
```

The root `.stylua.toml` defines the Lua 5.5 formatting rules used by local development and CI.

Use the Makefile entry points rather than invoking different formatter options manually:

```bash
make fmt        # Format all supported source and configuration files.
make fmt-swift  # Format only Swift.
make fmt-lua    # Format only Lua.
make fmt-md     # Format only Markdown.
make lint       # Check Swift and Lua formatting without modifying files.
make lint-lua   # Check only Lua formatting.
```

## Generated artifacts

Regenerate every checked-in generated artifact through the Makefile:

```bash
make generate
```

This runs the focused generators wired through the Makefile:

- `scripts/generate/theme_tokens.py` for theme-token Swift and Lua artifacts
- `scripts/generate/event_catalog.py` for event-token Lua artifacts and the combined LuaLS stub
- `EasyBarGenerateConfig` for `config.defaults.toml`

Use this before committing changes that affect generated Swift, Lua, or TOML artifacts.

Verify that generated artifacts are current before opening a pull request:

```bash
make check-generated
```

`make test` intentionally does not regenerate checked-in artifacts. Run `make generate` or
`make check-generated` explicitly when changing generated Swift or Lua outputs.

## Generated docs

Build the assembled site from the separate documentation repository:

```bash
make build
```

The documentation build fetches EasyBar and widgets, runs `scripts/generate/lua_docs.py`,
`EasyBarGenerateConfig config-docs`, and the widget catalog generator, then builds MkDocs from a
disposable content tree. Generated pages are never committed or synchronized between repositories.

## Helper scripts

Reusable automation scripts live under `scripts/` and are grouped by purpose:

- `scripts/build/` contains build helpers used by the Makefile, such as universal product builds, resource copying, plist stamping, and bundle verification.
- `scripts/ci/` contains CI helpers such as dependency setup and long-running Swift test logging.
- `scripts/dev/` contains local-development wrappers such as the shared run and stop flows.
- `scripts/release/` contains release helpers such as signing, notarization, Homebrew cask rendering, release verification, and tap commits.

Keep stable developer commands in the Makefile and delegate large reusable shell blocks into these
scripts. This keeps commands like `make run-debug`, `make generate`, and `make package` stable while
avoiding duplicated or hard-to-review shell logic.

## Notes

- the managed activation directory and manual widget directory contain executable Lua
- Swift passes `widgets_dir` and the internal managed activation path; `api.lua` owns recursive manual discovery and explicit managed activation discovery
- top-level managed activation symlinks load their declared package entrypoints; manual Lua files at any depth outside `shared/` are loaded as widgets
- reusable manual modules and package exports use `shared/`; there is no secondary module directory
- managed widget activation uses `active/<name>` symlinks that point directly to each committed version's declared entrypoint file; package directories are never recursively discovered
- declared package exports are activated below `active/shared/` with symlinks directly to their files in the owning committed version
- reload is a full reset
- protocol:
  - Lua socket JSON in/out via `EasyBarLuaRuntime`
  - stderr logs

## If you change the Lua API

When changing the Lua API:

1. update runtime code
2. update stubs
3. run `make generate` and `make check-generated` in EasyBar
4. update hand-written guides and examples in `easybar-app/docs`
5. run `make build` in the documentation repository
