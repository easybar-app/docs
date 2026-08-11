# Contributor Notes

Use this page when changing the Lua runtime or public Lua API. Public authoring behavior belongs in
[Lua Widgets](../../lua/overview.md); package-manager behavior belongs in
[Package Store Internals](../package-store.md).

## Where to change what

### Public widget API

- `api.lua`
- `easybar_api.base.lua`
- `easybar_api.events.lua`
- `easybar_api.lua`
- the matching `content/lua/` guide or reference in `easybar-app/docs`

`easybar_api.base.lua` is hand-edited. Event declarations and the combined editor stub include
generated content.

### Driver events and payloads

- `event_tokens.lua`
- `events.lua`
- `EventHub.swift`
- `EventTypes.swift`
- Swift event sources

### Loading and rendering

- `api.lua` for discovery
- `loader.lua` for per-source execution
- `registry.lua` for Lua-side node state
- `render.lua` for derived trees
- `WidgetNodeState.swift` and `WidgetStore.swift` for Swift-side application

### Process and transport

- `RuntimeCoordinator.swift`
- `WidgetEngine.swift`
- `LuaRuntime.swift`
- `LuaProcessController.swift`
- `LuaTransport.swift`
- `LuaLogBridge.swift`

## Runtime invariants

Keep these boundaries intact unless the architecture is intentionally changing:

- manual widget discovery is recursive below `widgets_dir` except `shared/`;
- managed widget discovery is explicit and top-level below the package activation root;
- managed activation links point directly to manifest-declared entrypoints;
- package exports and manual reusable modules load through `shared/` search paths;
- committed package directories are never recursively scanned by Lua;
- reload is a full Lua process reset;
- runtime protocol messages use the Lua socket;
- Lua logs use stderr;
- widget environments fall back to `_G` and are not a sandbox.

## Debugging the runtime

Start with the normal host logs:

```bash
<frontend-cli> logs --runtime lua --level trace --follow
```

Useful symptoms include missing `ready` or `subscriptions` messages, entrypoint load errors,
repeated subscriptions, runtime input overflows, and event queue overflows.

For Lua-only debugging, the bundled runtime can be launched directly from an EasyBar checkout:

```bash
lua Sources/EasyBarKit/Lua/runtime.lua <widget_dir>
```

That bypasses the normal launcher/socket lifecycle, so use it only to isolate Lua behavior. In the
full app path, Swift listens on the configured Lua socket, `EasyBarLuaRuntime` connects it, and then
execs the Lua interpreter.

When debugging loading, compare the two roots separately:

- managed entrypoints under the selected frontend package root, such as `~/.local/share/easybar/packages/active/` or `~/.local/share/easybar-native/packages/active/`;
- manual files under that frontend's configured `widgets_dir`.

Do not debug package activation by recursively running files from `store/`; that is intentionally not
how the runtime loads managed packages.

## Formatting and generated artifacts

Use the EasyBarKit repository Makefile entry points:

```bash
make fmt
make lint
make generate
make check-generated
```

`make generate` refreshes the checked-in theme, event, Lua stub, and generated config artifacts owned by EasyBarKit. `make test` does not regenerate them.

## Generated documentation

Build the assembled site from the separate docs repository:

```bash
make build
```

The documentation build fetches EasyBarKit and widgets, generates the EasyBar configuration and shared Lua reference,
generates the Widget Store catalog into ignored paths below `content/`, and then builds MkDocs
directly from that content tree. Generated pages are not committed to the documentation repository.

## If you change the Lua API

1. Update runtime code.
2. Update the hand-edited stubs or event catalog inputs.
3. Run `make generate` and `make check-generated` in EasyBar.
4. Update the relevant public Lua guide in `easybar-app/docs`.
5. Run `make build` in the documentation repository.
