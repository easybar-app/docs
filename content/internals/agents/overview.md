# Agents Overview

EasyBarKit provides two permission-sensitive helper products used by the full EasyBar frontend:

- `EasyBarCalendarAgent`;
- `EasyBarNetworkAgent`.

They run out of process, listen on local Unix sockets, and exchange typed newline-delimited JSON with
clients.

## Why agents exist

The agents keep permission-sensitive system APIs outside the main EasyBar frontend process:

- Calendar agent: EventKit permission, observation, snapshots, and mutations;
- Network agent: Location-sensitive Wi-Fi observation and network field collection.

EasyBarKit maps the typed data into EasyBar native built-in state and subscribed Lua events.

## EasyBar ownership

The normal service configuration is the EasyBar profile:

```text
~/.config/easybar/config.toml
~/.local/state/easybar/runtime/
```

Homebrew installs and supervises these agents for EasyBar. The `easybar` CLI exposes agent restart and
version commands.

## EasyBar Native boundary

EasyBar Native does not install, configure, start, stop, or require these helper services. It keeps
its own config and runtime directories and uses Lua widgets plus the host-owned Inbox surface.

The agent protocols and core libraries may still be reused by independent software. Reuse does not
make that software a dependency of EasyBar Native.

## Related pages

- [Agent Protocol](protocol.md)
- [Calendar Agent](calendar-agent.md)
- [Network Agent](network-agent.md)
- [EasyBar Agent Configuration](../../products/easybar/configuration/agents.md)
