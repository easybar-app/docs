# Lua Widgets

EasyBarKit Lua widgets are the shared public extension model used by both EasyBar frontends. A widget
creates nodes, keeps their handles, and updates them with methods such as `node:set(...)` and
`node:subscribe(...)`; it does not return widget trees directly.

Use Lua when you want:

- custom text, icons, or composed layouts;
- shell-command integration or local scripting;
- event-driven behavior, timers, clicks, popups, sliders, or context menus;
- a reusable integration that can be packaged independently of either frontend.

The frontend decides where the top-level root is hosted:

- **EasyBar** places it inside the custom full-width bar;
- **EasyBar Native** hosts it as a native macOS status item.

Package manifests target EasyBarKit rather than one frontend executable. A widget remains portable
unless it intentionally depends on a frontend-specific capability. In particular, the full EasyBar
product owns the Calendar and Network helper-agent sources; EasyBar Native does not provide those
agents merely because the event tokens exist in the shared API.

## Minimal widget

```lua
local clock

clock = easybar.add(easybar.kind.item, "clock", {
    position = "right",
    order = 10,
    label = os.date("%H:%M"),
    interval = 60,
    on_interval = function()
        clock:set({
            label = os.date("%H:%M"),
        })
    end,
})
```

## Mental model

1. create nodes with `easybar.add(...)`;
2. keep returned handles;
3. update nodes with `node:set(...)`;
4. subscribe with `node:subscribe(...)`;
5. let EasyBarKit render the current node state through the active frontend.

## Frontend-owned directories

The Lua API is shared, but manual widget and package roots are not:

|                  | EasyBar                                  | EasyBar Native                                  |
| ---------------- | ---------------------------------------- | ----------------------------------------------- |
| Manual widgets   | `~/.config/easybar/widgets`              | `~/.config/easybar-native/widgets`              |
| Managed packages | `~/.local/share/easybar/packages`        | `~/.local/share/easybar-native/packages`        |
| Editor stub      | `~/.local/share/easybar/easybar_api.lua` | `~/.local/share/easybar-native/easybar_api.lua` |

Install or edit the copy owned by the frontend you want to run.

## Guides

- [First Widget](guides/first-widget.md)
- [Conventions & Best Practices](guides/best-practices.md)
- [Reusable Modules](guides/modules.md)
- [Subscribe To Events](guides/subscribe-to-events.md)
- [Commands](guides/commands.md)
- [Widget Settings](guides/storage.md)
- [Grouping](guides/grouping.md) and [Popups](guides/popups.md)
- [Editor Support](guides/editor-support.md)
- [Examples](guides/examples.md)
- [Widget Store](../widget-store/index.md)

## Exact API reference

The generated reference comes from EasyBarKit and therefore describes the shared Lua contract:

- [Functions](reference/functions.md)
- [Node kinds](reference/node-kinds.md)
- [Events](reference/events.md)
- [Properties](reference/properties.md)

