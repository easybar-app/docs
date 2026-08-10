# Lua Conventions

This page defines the terms used across the EasyBar Lua docs.

## Widget

A widget is one Lua entrypoint executed by EasyBar. It may be a manually managed `.lua` file below your configured `widgets_dir` or the declared entrypoint of an installed Widget Store package.

The entrypoint can create one node or many nodes. It can also keep local state, run commands, subscribe to events, and update its own nodes over time.

## Module

A module is reusable Lua code loaded with standard `require(...)` calls. Put reusable manual modules below `shared/`; installable packages expose reusable Lua only through declared exports, which EasyBar activates below the managed `shared/` directory. Modules below `shared/` are not started as widgets.

See [Reusable Modules](guides/modules.md).

## Node

A node is one renderable unit in the EasyBar runtime.

Examples:

- an `item`
- a `group`
- a `row`
- a `column`
- a `popup`
- a `slider`

Node kinds are listed in [Node Kinds](reference/node-kinds.md).

## Handle

A handle is the object returned by `easybar.add(...)`.

You keep the handle in a local variable and call methods on it later:

- `node:set(...)`
- `node:get()`
- `node:remove()`
- `node:subscribe(...)`

See [Functions](reference/functions.md).

## Built-in

A built-in is a native widget configured in `config.toml` under `[builtins.*]`.

Built-ins are not Lua widgets, even when they resemble the same kind of visual element.

See [Built-ins Vs Lua](../getting-started/builtins-vs-lua.md).

## Group

A group is a node kind used to give multiple child nodes one shared container.

Use it when several items should share:

- one background
- one border
- one padding box
- one popup owner
- one overall layout block

See [Grouping](guides/grouping.md).

## Popup

A popup is extra content attached to a parent node.

Popup child nodes target a `position` of `popup.<parent-id>`. The parent node controls whether the popup is visible through `popup.drawing`.

See [Popups](guides/popups.md).

## Event

An event is a runtime signal that can trigger widget logic.

Examples:

- app switch
- space change
- volume change
- mouse enter
- mouse click
- slider preview

Events are exposed through `easybar.events.*`. Event names and payloads are documented in [Events](reference/events.md).

## Agent

An agent is a helper process used for permission-sensitive or platform-specific data collection, such as calendar or network state.

Agents are configured in `config.toml` and feed data back into EasyBar events and native widgets.

See [Agents](../configuration/agents.md).

## Runtime

The runtime is the host machinery that loads widget files, creates nodes, dispatches events, and applies updates between the Lua side and the native app.

See [Runtime Control](../runtime/control.md).

## Mental model

The shortest accurate mental model is:

1. a widget file creates nodes
2. EasyBar returns handles
3. your code stores those handles
4. events and timers trigger updates
5. `set(...)` mutates current node state

If you are just getting started, continue with [First Widget](guides/first-widget.md).
