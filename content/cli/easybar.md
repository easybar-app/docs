# EasyBar CLI

`easybar` controls the full-width EasyBar app and its supporting services. Commands that contact a
running process use EasyBar's runtime sockets; package commands work directly with EasyBar's package
store.

## Command groups

| Command group                           | Purpose                                                             |
| --------------------------------------- | ------------------------------------------------------------------- |
| `refresh`, `config`, `runtime`, `event` | Control the app, configuration, Lua runtime, and events.            |
| `widgets`                               | Search, install, update, and remove EasyBar widget packages.        |
| `inbox`                                 | Publish and manage EasyBar Inbox messages.                          |
| `logs`                                  | Read retained logs or follow live EasyBar and helper-agent records. |
| `metrics`                               | Inspect an EasyBar runtime snapshot or watch live metrics.          |
| `agent`                                 | Inspect or restart the calendar and network helper agents.          |

## Documentation

- [App, configuration, runtime, and events](easybar/control.md)
- [Widget packages](easybar/widgets.md)
- [Inbox](easybar/inbox.md)
- [Logs](easybar/logs.md)
- [Metrics](easybar/metrics.md)
- [Helper agents](easybar/agents.md)

## Help and version

```bash
easybar --help
easybar COMMAND --help
easybar --version
```

The CLI is installed with EasyBar. Its version should match the installed app after an upgrade.
