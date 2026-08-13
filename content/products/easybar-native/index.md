# EasyBar Native

EasyBar Native is the native macOS menu-bar frontend for EasyBarKit. Each top-level Lua widget root is
hosted as an independent `NSStatusItem` in the system status area instead of being placed inside
EasyBar's custom full-width bar.

Lua packages are the public widget extension model. EasyBar Native keeps one host-owned built-in
surface, **Inbox**, because Lua packages such as `inbox-github`, `inbox-gitlab`, and `inbox-brew`
publish structured messages into it. Regular EasyBar built-ins are not registered as Native status
items.

## Isolated by default

EasyBar Native does not share EasyBar's mutable user state:

```text
config       ~/.config/easybar-native/config.toml
widgets      ~/.config/easybar-native/widgets
packages     ~/.local/share/easybar-native/packages
editor stub  ~/.local/share/easybar-native/easybar_api.lua
runtime      ~/.local/state/easybar-native/runtime
logs         ~/.local/state/easybar-native/
CLI          easybar-native
```

It does not install, start, stop, or require EasyBar's calendar or network helper agents. Installing,
updating, or removing a Native widget package does not change EasyBar's package store.

## What is shared

EasyBar Native still reuses EasyBarKit for:

- Lua loading, events, timers, commands, storage, and process supervision;
- package validation, dependency resolution, and activation;
- SwiftUI node rendering, interactions, context menus, and popups;
- themes and widget presentation state;
- the host-owned Inbox surface;
- the underlying CLI implementation used by the `easybar-native` launcher.

Sharing implementation does not imply sharing config, runtime sockets, logs, packages, or helper
services.

## Status-area differences

macOS owns the system status area. `position = "left"`, `"center"`, or `"right"` therefore acts as a
relative ordering hint in EasyBar Native; it cannot create arbitrary full-width regions or draw one
background behind several system status items.

## Start here

- [Quick Start](quick-start.md)
- [Installation](installation.md)
- [Configuration & Paths](configuration.md)
- [Lua Widgets & Packages](widgets.md)
- [`easybar-native` CLI](../../cli/easybar-native/index.md)
- [Troubleshooting](troubleshooting.md)

If you need EasyBar's native calendar, Wi-Fi, battery, Spaces, or other built-ins in one designed bar,
use the [EasyBar frontend](../easybar/index.md). Native keeps those surfaces outside its product
boundary.
