# Conventions & Best Practices

This page defines the terminology used across the EasyBar Lua docs and the authoring practices that keep widgets predictable and easy to debug.

## Widget

A widget is one Lua entrypoint executed by EasyBar. It may be a manually managed `.lua` file below your configured `widgets_dir` or the declared entrypoint of an installed Widget Store package.

The entrypoint can create one node or many nodes. It can also keep local state, run commands, subscribe to events, and update its own nodes over time.

## Module

A module is reusable Lua code loaded with standard `require(...)` calls. Put reusable manual modules below `shared/`; installable packages expose reusable Lua only through declared exports, which EasyBar activates below the managed `shared/` directory. Modules below `shared/` are not started as widgets.

See [Reusable Modules](modules.md).

## Node

A node is one renderable unit in the EasyBar runtime.

Examples:

- an `item`
- a `group`
- a `row`
- a `column`
- a `popup`
- a `slider`

Node kinds are listed in [Node Kinds](../reference/node-kinds.md).

## Handle

A handle is the object returned by `easybar.add(...)`.

You keep the handle in a local variable and call methods on it later:

- `node:set(...)`
- `node:get()`
- `node:remove()`
- `node:subscribe(...)`

See [Functions](../reference/functions.md).

## Built-in

A built-in is a host-owned Swift surface. The full EasyBar product exposes its native widgets through `[builtins.*]`; EasyBar Native intentionally exposes only the host-owned Inbox surface. Built-ins are not Lua widgets.

See [Choose Built-ins, Widget Store, Or Lua](../../products/easybar/choosing-widgets.md) and [EasyBar Native](../../products/easybar-native/index.md).

## Group

A group is a node kind used to give multiple child nodes one shared container.

Use it when several items should share:

- one background
- one border
- one padding box
- one popup owner
- one overall layout block

See [Grouping](grouping.md).

## Popup

A popup is extra content attached to a parent node.

Popup child nodes target a `position` of `popup.<parent-id>`. The parent node controls whether the popup is visible through `popup.drawing`.

See [Popups](popups.md).

## Event

An event is a runtime signal that can trigger widget logic.

Examples:

- app switch
- space change
- volume change
- mouse enter
- mouse click
- slider preview

Events are exposed through `easybar.events.*`. Event names and payloads are documented in [Events](../reference/events.md).

## Agent

An EasyBar agent is a helper process used by the full EasyBar product for permission-sensitive calendar or network collection. EasyBar Native does not require those agents.

See [Helper Agents](../../platform/helper-agents.md).

## Runtime

The runtime is the EasyBarKit machinery that loads widget files, creates nodes, dispatches events, and applies updates between Lua and the selected frontend. Use [`easybar`](../../cli/easybar/index.md) for EasyBar runtime control or [`easybar-native`](../../cli/easybar-native/index.md) for EasyBar Native.

## Mental model

The shortest accurate mental model is:

1. a widget file creates nodes
2. EasyBarKit returns handles
3. your code stores those handles
4. events and timers trigger updates
5. `set(...)` mutates current node state

If you are just getting started, continue with [First Widget](first-widget.md).

## Authoring practices

### Use stable IDs

Node IDs should be stable across reloads:

```lua
easybar.add(easybar.kind.item, "brew_outdated", {
    position = "right",
})
```

Avoid dynamic IDs unless you are intentionally creating a dynamic list.

### Store handles

Always keep the handle returned by `easybar.add(...)` when the node needs updates or subscriptions.

```lua
local clock = easybar.add(easybar.kind.item, "clock", {
    label = os.date("%H:%M"),
})
```

### Prefer state-driven rendering

Keep state in Lua variables and render from that state.

```lua
local count = 0
local widget

local function render()
    widget:set({
        label = tostring(count),
    })
end
```

### Prefer groups for composite widgets

Use `group` when multiple child nodes belong together visually.

Use child subscriptions when only specific parts should be clickable.

### Prefer theme values for shared styling

Use `easybar.theme.colors.<token>` when you want one resolved hex color in Lua.

Use `easybar.theme.ref.<token>` when a node color field should stay coupled to the active theme.

### Use events before polling

Prefer event subscriptions for real runtime events.

Use intervals only for polling external state.

### Avoid blocking the runtime

Prefer `easybar.spawn_async(...)` for ordinary executable invocations and `easybar.exec_async(...)` only when shell syntax is required. Use `easybar.after(...)` for delays instead of launching `sleep`.

Avoid expensive synchronous work in mouse handlers, interval callbacks, and frequent events.

### Keep side effects inside handlers

Avoid doing too much work at file load time.

Good places for side effects:

- `on_interval`
- `node:subscribe(...)` handlers
- explicit refresh functions

### Format with StyLua

Use StyLua to keep widget files consistently formatted:

```bash
brew install stylua
stylua ~/.config/easybar/widgets
```

For EasyBar Native, use `~/.config/easybar-native/widgets` instead. Check formatting without changing files with `stylua --check <widgets_dir>`.
