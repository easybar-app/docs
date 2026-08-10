# Agents Overview

EasyBarKit provides two helper processes:

- `EasyBarCalendarAgent`
- `EasyBarNetworkAgent`

Both run out of process, listen on local Unix sockets, and exchange newline-delimited JSON with
clients. Either EasyBar frontend can consume the same agent protocols; the network protocol is also
reused by standalone clients such as `wifi-snitch`.

## Why agents exist

The agents keep permission-sensitive system APIs out of frontend processes.

EasyBarKit stays focused on:

- shared widget/runtime coordination;
- consuming agent data and building presentation state;
- rendering that state through the active frontend surface.

The agents stay focused on:

- permission ownership;
- system observation and mutations;
- normalized data collection;
- socket delivery.

The boundary is deliberate: agents collect data, EasyBarKit decides how shared widget state is
presented, and a frontend decides where that widget surface is hosted.

For example, the network agent returns RSSI while EasyBarKit maps RSSI into Wi-Fi bars.

## Runtime config

The separately managed agents use the shared EasyBar agent configuration. By default this is:

```text
~/.config/easybar/config.toml
~/.local/state/easybar/runtime/
```

Relevant config:

```toml
[app]
runtime_dir = "~/.local/state/easybar/runtime"

[logging]
enabled = false
level = "info"
directory = "~/.local/state/easybar"

[agents.calendar]
enabled = true

[agents.network]
enabled = true
refresh_interval_seconds = 60
allow_unauthorized_non_sensitive_fields = false
```

Socket paths are derived from `app.runtime_dir` unless their individual `socket_path` values are
set. The custom EasyBar frontend uses these defaults directly. EasyBar Native keeps its own app/Lua
runtime directory but points its agent clients at the shared agent sockets by default.

## Service lifecycle

Homebrew installs the agents independently of a frontend process and supervises them as services.
Frontends connect over Unix sockets; they do not own the service process lifecycle. If an enabled
agent exits after an acknowledged restart or an unexpected failure, its service supervisor is
responsible for relaunching it.
