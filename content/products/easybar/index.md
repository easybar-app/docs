# EasyBar

EasyBar is the customizable full-width macOS top-bar frontend. It combines native SwiftUI built-ins
with the shared EasyBarKit Lua runtime and package system.

Use EasyBar when you want:

- one managed full-width bar surface;
- left, center, and right layout regions;
- native built-ins such as Spaces, battery, Wi-Fi, calendar, volume, CPU, and Inbox;
- native groups, themes, and bar-level appearance control;
- the Calendar and Network helper agents for permission-sensitive data;
- Lua widgets and Widget Store packages beside the native built-ins.

## Default paths

```text
config       ~/.config/easybar/config.toml
widgets      ~/.config/easybar/widgets
packages     ~/.local/share/easybar/packages
editor stub  ~/.local/share/easybar/easybar_api.lua
runtime      ~/.local/state/easybar/runtime
logs         ~/.local/state/easybar/
CLI          easybar
```

## Start here

1. [Quick Start](quick-start.md)
2. [Installation](installation.md)
3. [Configuration](configuration/overview.md)
4. [Choose Built-ins, Store, Or Lua](choosing-widgets.md)
5. [CLI Reference](../../cli/easybar.md)
6. [Troubleshooting](runtime/troubleshooting.md)

For the native status-area alternative, see [EasyBar Native](../easybar-native/index.md).
