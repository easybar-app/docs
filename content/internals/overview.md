# Internals

This section is for contributors and maintainers. Normal installation, package management,
configuration, and widget authoring should stay in the public sections of the site.

Use these instead for user-facing tasks:

- [Getting Started](../getting-started/quick-start.md) for installation and first setup;
- [Widget Store](../widget-store/overview.md) for package discovery and management;
- [Configuration](../configuration/overview.md) for `config.toml`;
- [Lua Widgets](../lua/overview.md) for the public scripting API;
- [Runtime](../runtime/control.md) for CLI control, logs, metrics, and recovery.

## What belongs in internals

Internals explain implementation ownership rather than user workflows:

- Swift targets and process boundaries;
- helper-agent protocols;
- control-socket and event flow;
- package-store transactions and activation;
- Lua process lifecycle, loading, transport, backpressure, and rendering;
- generated artifacts and contributor workflows.

## Contributor path

A practical reading order is:

1. [Development](development.md)
2. [Architecture Overview](architecture/overview.md)
3. [Process Model](architecture/process-model.md)
4. [Architectural Boundaries](architecture/boundaries.md)
5. the subsystem you are changing:
   - [Package Store](package-store.md)
   - [Agent Protocol](agents/protocol.md)
   - [Lua Runtime](lua-runtime/overview.md)

Use [Targets](architecture/targets.md) when you need exact source ownership.

## Architecture

- [Architecture Overview](architecture/overview.md)
- [Targets](architecture/targets.md)
- [Process Model](architecture/process-model.md)
- [Shared Layer](architecture/shared-layer.md)
- [CLI](architecture/cli.md)
- [Control Socket](architecture/control-socket.md)
- [Event Flow](architecture/event-flow.md)
- [Boundaries](architecture/boundaries.md)

## Package store

- [Package Store Internals](package-store.md)

## Agents

- [Agents Overview](agents/overview.md)
- [Agent Protocol](agents/protocol.md)
- [Calendar Agent](agents/calendar-agent.md)
- [Network Agent](agents/network-agent.md)

## Lua runtime

- [Lua Runtime Overview](lua-runtime/overview.md)
- [Lifecycle](lua-runtime/lifecycle.md)
- [Widget Loading](lua-runtime/widget-loading.md)
- [Events](lua-runtime/events.md)
- [Contributor Notes](lua-runtime/contributor-notes.md)
