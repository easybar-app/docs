# EasyBar Native CLI

`easybar-native` controls EasyBar Native and its isolated Lua widget environment. Commands that
contact the app use the Native runtime socket; package commands work directly with the Native package
store.

## Command groups

| Command group                           | Purpose                                                             |
| --------------------------------------- | ------------------------------------------------------------------- |
| `refresh`, `config`, `runtime`, `event` | Control EasyBar Native, its configuration, Lua runtime, and events. |
| `widgets`                               | Search, install, update, and remove Native widget packages.         |
| `inbox`                                 | Publish and manage EasyBar Native Inbox messages.                   |
| `logs`                                  | Read retained logs or follow live Native app and Lua records.       |
| `metrics`                               | Inspect a Native runtime snapshot or watch live metrics.            |

## Documentation

- [App, configuration, runtime, and events](control.md)
- [Widget packages](widgets.md)
- [Inbox](inbox.md)
- [Logs](logs.md)
- [Metrics](metrics.md)

## Help and version

```bash
easybar-native --help
easybar-native COMMAND --help
easybar-native --version
```

The CLI is bundled with EasyBar Native and installed as the `easybar-native` command.

