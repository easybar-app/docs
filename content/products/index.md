# Products

EasyBar has two user-facing macOS frontends. They share EasyBarKit's Lua API, renderer, package
manager, and CLI core, but they are separate applications with separate commands and user data.

## Which frontend should I use?

Choose **EasyBar** when you want to replace the menu-bar layout with one designed, full-width surface.
Choose **EasyBar Native** when you want Lua widgets to live beside ordinary macOS menu-bar apps as
independent status items.

| Capability              | EasyBar                                                    | EasyBar Native                                     |
| ----------------------- | ---------------------------------------------------------- | -------------------------------------------------- |
| Presentation            | One custom full-width top bar                              | Independent macOS `NSStatusItem`s                  |
| Public widget model     | Native built-ins and Lua widgets                           | Lua widgets                                        |
| Host-owned built-in     | Spaces, battery, Wi-Fi, calendar, volume, CPU, Inbox, more | Inbox only                                         |
| Layout control          | Left, center, and right regions; groups; bar geometry      | Relative item order; macOS owns final placement    |
| Lua API and packages    | Shared EasyBarKit contract                                 | Shared EasyBarKit contract                         |
| Calendar/network agents | Installed and managed                                      | Not installed, required, or managed                |
| CLI                     | `easybar`                                                  | `easybar-native`                                   |
| Config                  | `~/.config/easybar/config.toml`                            | `~/.config/easybar-native/config.toml`             |
| Manual widgets          | `~/.config/easybar/widgets`                                | `~/.config/easybar-native/widgets`                 |
| Managed packages        | `~/.local/share/easybar/packages`                          | `~/.local/share/easybar-native/packages`           |
| Runtime                 | `~/.local/state/easybar/runtime`                           | `~/.local/state/easybar-native/runtime`            |
| Main log                | `~/.local/state/easybar/easybar.out`                       | `~/.local/state/easybar-native/easybar-native.out` |

!!! important "EasyBar Native's built-in boundary"

    EasyBar Native does not expose EasyBar's regular Swift built-ins as status items. Its public
    extension surface is Lua widgets, with Inbox retained as the one host-owned built-in so Lua
    publisher packages have a common destination.

## Can I install both?

Yes. Installing both is useful when you want to compare presentation styles or migrate gradually.
They do not share config files, runtime sockets, logs, package activation state, or CLI names.

Installing the same package twice creates two independent installations:

```bash
easybar widgets install tailscale
easybar-native widgets install tailscale
```

Use the matching command to reload the frontend you changed:

```bash
easybar config reload
easybar-native config reload
```

## Package compatibility

Most packages that use only the shared Lua API work in either frontend. Installation through a
frontend's CLI does not by itself guarantee that every external requirement is available there.
Check each package page for required commands and frontend-specific behavior.

A package is not portable to EasyBar Native when it requires an EasyBar-only helper agent, built-in,
or the `easybar` executable. Inbox publisher packages are portable when they use the shared Inbox API
and do not otherwise depend on an EasyBar-only capability.

## Start here

| Goal                                            | Guide                                                                                     |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Build a complete custom bar                     | [EasyBar Quick Start](easybar/quick-start.md)                                             |
| Add Lua widgets to the normal macOS status area | [EasyBar Native Quick Start](easybar-native/quick-start.md)                               |
| Use the product command-line tools              | [`easybar`](../cli/easybar/index.md) / [`easybar-native`](../cli/easybar-native/index.md) |
| Browse shared packages                          | [Widget Store](../widget-store/index.md)                                                  |
