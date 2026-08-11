# Control Socket

Each EasyBarKit frontend exposes its own local Unix control socket inside that frontend's runtime
directory.

Default sockets are:

```text
EasyBar        ~/.local/state/easybar/runtime/easybar.sock
EasyBar Native ~/.local/state/easybar-native/runtime/easybar.sock
```

The filename is shared because the parent runtime directories are not.

## Purpose

The control socket handles typed JSON requests for operations such as:

- manual refresh;
- Lua runtime restart;
- config reload/validation;
- metrics;
- Inbox reads and mutations;
- supported scripting events.

`easybar` resolves the EasyBar socket. `easybar-native` resolves the Native socket. An explicit socket
override can be used by commands that support it, but the normal command name should already select
the correct frontend.

The internal `manual_refresh` command is exposed to Lua widgets as the public `forced` event, keeping
the control protocol separate from the Lua event name.

## Agent sockets are separate

Calendar and Network agent sockets are not frontend control sockets. They belong to the EasyBar
helper services and are used by `easybar agent ...` or EasyBarKit's EasyBar-side agent clients.
EasyBar Native does not derive its normal operation from those agent sockets.
