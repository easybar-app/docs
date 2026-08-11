# Logs

The `easybar-native logs` command reads retained Native logs and can continue with matching live
records.

```bash
easybar-native logs
easybar-native logs --follow
easybar-native logs --widget tailscale --runtime lua --level debug
easybar-native logs --runtime app --since 30m
easybar-native logs --request-id lua-19 --json
```

| Option                | Purpose                                                        |
| --------------------- | -------------------------------------------------------------- |
| `--widget NAME`       | Match one Lua widget.                                          |
| `--runtime KIND`      | Match `app` or `lua`.                                          |
| `--level LEVEL`       | Match `trace`, `debug`, `info`, `warn`, or `error` and higher. |
| `--request-id ID`     | Match one request across retained records.                     |
| `--since TIME`        | Match a duration such as `30m` or an ISO-8601 timestamp.       |
| `--lines COUNT`, `-n` | Limit retained output to the latest matching records.          |
| `--all`               | Print all retained matching records.                           |
| `--follow`, `-f`      | Continue with new matching records.                            |
| `--json`              | Emit JSON Lines.                                               |

Logs are read from EasyBar Native's state below `~/.local/state/easybar-native`. See
[Native troubleshooting](../../products/easybar-native/troubleshooting.md) for common runtime and
widget failures.
