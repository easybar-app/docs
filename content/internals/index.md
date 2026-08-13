# Internals

This section is for contributors working across the EasyBar project family. User-facing docs are
organized by product and tool so architecture pages do not need to double as installation guides.

The implementation is split across:

```text
easybar-kit
easybar
easybar-native
widgets
registry
docs
```

Start with [Architecture Overview](architecture/index.md) for the runtime boundary or
[Repositories](../platform/repositories.md) for ownership at a glance.

## Public documentation lives elsewhere

- [Products](../products/index.md) — choose and configure EasyBar or EasyBar Native;
- [`easybar`](../cli/easybar/index.md) and [`easybar-native`](../cli/easybar-native/index.md) — product command-line tools;
- [Lua Widgets](../lua/index.md) — shared authoring contract;
- [Widget Store](../widget-store/index.md) — package discovery and management;
- [Platform](../platform/index.md) — EasyBarKit and helper-product positioning.

## Contributor path

A practical reading order is:

1. [Development](development.md)
2. [Architecture Overview](architecture/index.md)
3. [Process Model](architecture/process-model.md)
4. [Architectural Boundaries](architecture/boundaries.md)
5. the subsystem you are changing:
   - [Package Store](package-store.md)
   - [Agent Protocol](agents/protocol.md)
   - [Lua Runtime](lua-runtime/index.md)

## Architecture

- [Architecture Overview](architecture/index.md)
- [Targets](architecture/targets.md)
- [Process Model](architecture/process-model.md)
- [Shared Layer](architecture/shared-layer.md)
- [CLI Core](architecture/cli-core.md)
- [Control Socket](architecture/control-socket.md)
- [Event Flow](architecture/event-flow.md)
- [Boundaries](architecture/boundaries.md)

## Agents

- [Agents Overview](agents/index.md)
- [Agent Protocol](agents/protocol.md)
- [Calendar Agent](agents/calendar-agent.md)
- [Network Agent](agents/network-agent.md)

## Lua runtime

- [Lua Runtime Overview](lua-runtime/index.md)
- [Lifecycle](lua-runtime/lifecycle.md)
- [Widget Loading](lua-runtime/widget-loading.md)
- [Events](lua-runtime/events.md)
- [Contributor Notes](lua-runtime/contributor-notes.md)

