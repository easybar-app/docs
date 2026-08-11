# App and runtime control

These commands control the running EasyBar Native app, its active configuration, and its Lua runtime.

## Refresh widgets

```bash
easybar-native refresh
```

Refresh Inbox and Lua widget state without rereading configuration or restarting the Lua runtime.

## Reload configuration

```bash
easybar-native config reload
```

Reread `~/.config/easybar-native/config.toml` and rebuild the Native widget items. A rejected reload
leaves the last valid configuration active.

## Validate configuration

```bash
easybar-native config validate
easybar-native config validate --config /path/to/config.toml
```

Validation checks configuration without applying it.

## Restart the Lua runtime

```bash
easybar-native runtime restart
```

Restart the Lua process and reload widget files using the configuration already held by EasyBar
Native. This does not reread `config.toml`.

## Emit an event

```bash
easybar-native event emit workspace_change
```

Use event emission from local scripts to refresh subscribed Lua widgets.

## Socket and diagnostic options

```bash
easybar-native refresh --socket ~/.local/state/easybar-native/runtime/easybar.sock
easybar-native refresh --debug
```

`--socket` overrides the Native control socket for supported commands. `--debug` prints CLI
diagnostics without changing application log levels.
