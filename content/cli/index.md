# Command-line tools

EasyBar has two public CLI names because the two frontends own separate runtime and package state.
The commands intentionally look similar, but the selected executable determines which frontend you
control.

| Command          | Controls       | Package store                            | Helper-agent commands |
| ---------------- | -------------- | ---------------------------------------- | --------------------- |
| `easybar`        | EasyBar        | `~/.local/share/easybar/packages`        | Yes                   |
| `easybar-native` | EasyBar Native | `~/.local/share/easybar-native/packages` | No                    |

## Same command, different owner

```bash
easybar widgets install tailscale
easybar-native widgets install tailscale
```

These are two independent installations of the same package release. The first affects EasyBar; the
second affects EasyBar Native.

Likewise:

```bash
easybar config reload
easybar-native config reload
```

target different control sockets and config files.

## Shared command model

Both commands reuse the EasyBarKit CLI implementation for frontend control, package management,
metrics, Inbox operations, and diagnostics. Native supplies a frontend profile that changes its
paths, display name, and available command groups instead of forking the parser and package manager.

Continue with [`easybar`](easybar.md) or [`easybar-native`](easybar-native.md).
