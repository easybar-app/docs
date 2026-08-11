# Agent Diagnostics

Use this page when the calendar or network agent needs deeper process, socket, permission, or raw-data checks. Start with [Troubleshooting](troubleshooting.md) for normal user-facing symptoms.

EasyBar's calendar and network agents are independent Homebrew services. The main app consumes their data over Unix sockets; opening or restarting the bar is not a substitute for checking the agent service itself.

## Check processes and services

```bash
pgrep -fl EasyBarCalendarAgent
pgrep -fl EasyBarNetworkAgent
brew services list | grep easybar
```

Compare the versions of the running agents with EasyBar:

```bash
easybar agent version all
```

If a responsive agent needs a clean restart, prefer the socket command:

```bash
easybar agent restart calendar
easybar agent restart network
```

If its socket is unresponsive or the process is absent, restart the Homebrew service instead:

```bash
brew services restart easybar-calendar-agent
brew services restart easybar-network-agent
```

## Check logs

Enable retained debug logs when necessary:

```toml
[logging]
enabled = true
level = "debug"
```

Agent logs are stored in the configured EasyBar log directory, normally:

```text
~/.local/state/easybar/calendar-agent.out
~/.local/state/easybar/network-agent.out
```

For temporary trace-level inspection without retaining trace records:

```bash
easybar logs --runtime agent --level trace --follow
```

See [Logs](../../../cli/easybar/logs.md) for filters and live-follow behavior.

## Probe an agent socket

The default sockets live below `~/.local/state/easybar/runtime/` unless config or `EASYBAR_RUNTIME_DIR` overrides them.

Ping the network agent:

```bash
echo '{"command":"ping"}' | nc -U ~/.local/state/easybar/runtime/network-agent.sock
```

Expected response:

```json
{ "kind": "pong" }
```

Fetch selected network fields:

```bash
echo '{"command":"fetch","fields":["wifi.ssid","network.ipv4_address","network.ipv6_address","wifi.rssi","wifi.link_quality"]}' \
  | nc -U ~/.local/state/easybar/runtime/network-agent.sock
```

Namespace selectors are useful for broader inspection:

```bash
echo '{"command":"fetch","fields":["wifi.*"]}' \
  | nc -U ~/.local/state/easybar/runtime/network-agent.sock

echo '{"command":"fetch","fields":["network.*"]}' \
  | nc -U ~/.local/state/easybar/runtime/network-agent.sock
```

Use raw socket requests only for diagnostics. Normal EasyBar use should go through the app, CLI, and configured built-ins.

## Wi-Fi fields are missing

Wi-Fi identity fields require macOS Location Services permission. Also check that Wi-Fi is enabled and an active Wi-Fi interface exists.

After changing Location permission, restart the network agent:

```bash
easybar agent restart network
```

If IPv4 or IPv6 is missing from the built-in Wi-Fi widget, compare the raw fields first:

```bash
echo '{"command":"fetch","fields":["network.ipv4_address","network.ipv6_address"]}' \
  | nc -U ~/.local/state/easybar/runtime/network-agent.sock
```

If the values are present there but not in the widget, check the configured fields:

```toml
[builtins.wifi.content]
mode = "details"

[builtins.wifi.fields]
ipv4_address = true
ipv6_address = true
```

Then reload config:

```bash
easybar config reload
```

## Calendar is empty

Calendar access belongs to the calendar agent. Check that the service is running, Calendar permission is granted, and configured filters do not exclude the visible calendars.

After changing Calendar permission:

```bash
easybar agent restart calendar
```

## Calendar request is permanently rejected

A log such as:

```text
month calendar agent client request permanently rejected code=invalid_request
```

means the socket worked but the agent rejected that request. Calendar fetch and subscription ranges may span at most 366 days. EasyBar stops retrying an identical invalid request and keeps the last valid snapshot until the request or socket configuration changes.

After correcting the configuration or request, reload EasyBar:

```bash
easybar config reload
```

Do not diagnose `invalid_request` as a missing socket. A repeated connect/reconnect loop for the same rejected request indicates incorrect client behavior.

## Locate the failing layer

| Observation                               | Likely layer                           |
| ----------------------------------------- | -------------------------------------- |
| No socket response                        | Agent process, service, or socket path |
| Field missing from raw response           | Agent or current system state          |
| Raw field present but native widget wrong | EasyBar mapping or widget config       |
| Raw data correct but Lua behavior wrong   | Lua event mapping or widget code       |

A useful order is:

```text
agent service → socket response → EasyBar mapping → config/Lua → rendered UI
```

This avoids debugging presentation code before confirming the underlying data source.
