# Process Model

EasyBarKit supports two frontend applications. Each frontend runs its own runtime instance and
control socket.

## Runtime processes

A running frontend consists of:

- one `EasyBar` **or** `EasyBarNative` application process;
- one Lua runtime child process when Lua widgets are enabled;
- connections to the independently managed calendar and network agents;
- one `easybar` CLI process per command invocation.

The custom and native frontends use different default config/runtime directories, so they can be
developed or run independently. They may share the separately installed calendar and network agents.

## Single-instance guard

Single-instance locking is scoped to the frontend identity and its runtime directory. A second copy
of the same frontend exits rather than creating duplicate surfaces. The two different frontends are
not treated as the same application identity.

## Helper agents

Helper agents are separate processes because they own permission-sensitive APIs:

- EventKit for calendar access;
- Wi-Fi and network APIs that depend on Location Services permission.

The agents collect and normalize data. EasyBarKit consumes that data and renders it through whichever
frontend is active.

The agents communicate over Unix sockets and are independently supervised when installed as
services. Frontends do not embed or own their service lifecycle.

## Lua runtime process

Lua widgets do not execute in-process inside either frontend.

EasyBarKit starts a separate Lua runtime process and communicates with it over a dedicated Unix
socket. This provides crash isolation, full runtime reset on restart, and a clear JSON transport
boundary.
