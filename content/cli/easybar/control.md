# App and runtime control

These commands control the running EasyBar app, its active configuration, and its Lua runtime.

## Refresh displayed state

```bash
easybar refresh
```

Refresh native widgets, Lua widgets, and agent-backed data without rereading `config.toml` or
restarting the Lua runtime. The command also emits `easybar.events.forced` to subscribed widgets.

## Reload configuration

```bash
easybar config reload
```

Reread the active configuration and rebuild EasyBar. A rejected reload leaves the last valid
configuration active.

## Validate configuration

```bash
easybar config validate
easybar config validate --config /path/to/config.toml
```

Validation checks configuration without applying it. `--config` selects a different file for that
invocation.

## Restart the Lua runtime

```bash
easybar runtime restart
```

Restart the Lua process and reload Lua widget files using the configuration already held by EasyBar.
This does not reread `config.toml`.

## Emit an event

```bash
easybar event emit workspace_change
easybar event emit focus_change
easybar event emit space_mode_change
```

Use events from local scripts when an external action should refresh subscribed Lua widgets.
Hyphens and underscores are both accepted in event names.

## Socket and diagnostic options

```bash
easybar refresh --socket ~/.local/state/easybar/runtime/easybar.sock
easybar refresh --debug
```

`--socket` overrides the relevant socket for supported commands. `--debug` reports CLI diagnostics
without changing application log levels.

See [Runtime Control](../../products/easybar/runtime/control.md) for guidance on choosing refresh,
reload, or restart.
