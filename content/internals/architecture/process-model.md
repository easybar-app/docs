# Process Model

EasyBarKit supports two frontend applications. Each frontend owns its own runtime instance, control
socket, config, Lua child, and mutable package state.

## EasyBar processes

A normal EasyBar installation can involve:

- `EasyBar`;
- one `EasyBarLuaRuntime` child while Lua widgets are active;
- `EasyBarCalendarAgent` as a separately supervised service;
- `EasyBarNetworkAgent` as a separately supervised service;
- one `easybar` CLI process per invocation.

The full frontend connects to the helper agents because its Calendar and Wi-Fi built-ins consume
those services.

## EasyBar Native processes

A normal EasyBar Native installation involves:

- `EasyBarNative`;
- one `EasyBarLuaRuntime` child while Lua widgets are active;
- one `easybar-native` launcher plus its short-lived private CLI core process per invocation.

EasyBar Native does not require or manage the EasyBar Calendar and Network agents.

## Isolation

Default ownership is frontend-specific:

```text
EasyBar        ~/.config/easybar              ~/.local/share/easybar              ~/.local/state/easybar
EasyBar Native ~/.config/easybar-native       ~/.local/share/easybar-native       ~/.local/state/easybar-native
```

Single-instance locking is scoped to the frontend identity and runtime directory. Running EasyBar
and EasyBar Native at the same time does not make them the same application instance.

## Lua runtime

Lua widgets do not execute in either frontend process. EasyBarKit starts a separate Lua runtime and
communicates with it over that frontend's dedicated Unix socket. A reload replaces the complete Lua
process, which gives deterministic state reset and crash isolation.
