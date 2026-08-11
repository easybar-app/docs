# Products

EasyBar has two user-facing macOS frontends. They depend on the same EasyBarKit implementation but
are intentionally separate applications with separate commands and separate user data.

|                         | EasyBar                              | EasyBar Native                                     |
| ----------------------- | ------------------------------------ | -------------------------------------------------- |
| Presentation            | Custom full-width top bar            | macOS `NSStatusItem`s                              |
| Public widget model     | Native built-ins + Lua widgets       | Lua widgets + host-owned Inbox                     |
| CLI                     | `easybar`                            | `easybar-native`                                   |
| Config                  | `~/.config/easybar/config.toml`      | `~/.config/easybar-native/config.toml`             |
| Manual widgets          | `~/.config/easybar/widgets`          | `~/.config/easybar-native/widgets`                 |
| Packages                | `~/.local/share/easybar/packages`    | `~/.local/share/easybar-native/packages`           |
| Runtime                 | `~/.local/state/easybar/runtime`     | `~/.local/state/easybar-native/runtime`            |
| Main log                | `~/.local/state/easybar/easybar.out` | `~/.local/state/easybar-native/easybar-native.out` |
| Calendar/network agents | Installed and used                   | Not required or managed                            |

## EasyBar

Choose [EasyBar](easybar/index.md) when you want one designed bar surface with native macOS
integrations, grouping, custom geometry, and Lua extensions.

## EasyBar Native

Choose [EasyBar Native](easybar-native/index.md) when you want Lua widgets to live in the normal macOS
status area as independent native menu-bar items and you prefer an isolated, minimal frontend.

You can install both. They do not share config files, runtime sockets, package activation state, or
CLI names.
