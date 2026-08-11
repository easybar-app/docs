# Shared Layer

`EasyBarShared` contains models and utilities used across several EasyBarKit executables and
frontends.

Typical responsibilities include:

- shared runtime/config value types;
- typed IPC requests and responses;
- socket-path helpers;
- environment/bootstrap key definitions;
- logging primitives and log-level models;
- package/runtime path helpers used by the shared CLI core.

A shared type describes a contract; it does not imply that every process uses the same physical file
or directory.

## Path profiles

The normal EasyBar defaults live below `easybar`, while EasyBar Native supplies bootstrap overrides
below `easybar-native`. Shared path helpers resolve the active profile instead of hard-coding one
mutable store into every frontend.

## Logging

`ProcessLogger` and log filtering are shared implementation. Persistent log roots are frontend-owned:

```text
EasyBar        ~/.local/state/easybar/
EasyBar Native ~/.local/state/easybar-native/
```

EasyBar's Calendar and Network agents use the EasyBar logging/config profile because they belong to
the EasyBar product boundary. Native does not aggregate those services into its own installation.

`EASYBAR_LOG_LEVEL` remains the narrow diagnostic override for minimum severity. CLI `--debug` affects
only the CLI process, while live log subscriptions request their own transient filter level.
