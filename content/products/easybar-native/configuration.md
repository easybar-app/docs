# EasyBar Native Configuration & Paths

EasyBar Native uses the shared EasyBarKit config parser but supplies its own frontend defaults. Its
normal config file is:

```text
~/.config/easybar-native/config.toml
```

A config file is optional. Create one only when you need to override defaults or provide widget
settings.

## Default paths

| Purpose                   | Default                                         |
| ------------------------- | ----------------------------------------------- |
| Config                    | `~/.config/easybar-native/config.toml`          |
| Manual widgets            | `~/.config/easybar-native/widgets`              |
| Runtime sockets and locks | `~/.local/state/easybar-native/runtime`         |
| Main log directory        | `~/.local/state/easybar-native`                 |
| Managed packages          | `~/.local/share/easybar-native/packages`        |
| Lua editor stub           | `~/.local/share/easybar-native/easybar_api.lua` |

The control socket is `easybar.sock` inside the Native runtime directory. The Lua transport socket is
`lua-runtime.sock` in the same directory.

## Useful config sections

The shared schema contains settings used by more than one EasyBarKit frontend. In EasyBar Native,
the most relevant sections are:

- `[app]` and `[app.env]` for runtime, widget, command, and environment behavior;
- `[logging]` for Native file logging;
- `[theme]` and `[theme.colors]` for shared visual tokens used by Lua widgets and Inbox;
- `[builtins.inbox]` for the host-owned Inbox surface;
- `[widgets.<name>]` for Lua-owned persistent settings.

Example:

```toml
[logging]
enabled = true
level = "info"
directory = "~/.local/state/easybar-native"

[builtins.inbox]
enabled = true
position = "right"
order = 5

[widgets.tailscale]
# Package-owned settings belong here when the widget documents them.
```

## Settings that are not Native surfaces

The shared parser may recognize EasyBar-only sections such as `[bar]`, regular `[builtins.*]`,
`[builtins.groups.*]`, and `[agents.*]`. EasyBar Native does not turn those into regular Native
status items and does not own the EasyBar Calendar or Network agent lifecycle.

Do not use those sections as a way to add battery, Wi-Fi, calendar, Spaces, or other EasyBar built-ins
to the Native status area. Use Lua packages or independent macOS menu-bar applications instead.

## Bootstrap environment overrides

EasyBarKit supports narrow path overrides used by frontend launchers and diagnostics:

| Variable                          | Purpose                                                |
| --------------------------------- | ------------------------------------------------------ |
| `EASYBAR_CONFIG_PATH`             | Select another config file.                            |
| `EASYBAR_RUNTIME_DIR`             | Override `[app].runtime_dir`.                          |
| `EASYBAR_WIDGETS_DIR`             | Set the manual-widget fallback.                        |
| `EASYBAR_WIDGET_PACKAGES_DIR`     | Select the managed package root.                       |
| `EASYBAR_LOGGING_DIR`             | Set the logging-directory fallback.                    |
| `EASYBAR_WIDGET_EDITOR_STUB_PATH` | Set the editor-stub fallback.                          |
| `EASYBAR_LOG_LEVEL`               | Temporarily override the configured minimum log level. |

`EASYBAR_CONFIG_PATH`, `EASYBAR_RUNTIME_DIR`, and `EASYBAR_LOG_LEVEL` are true process-level
overrides. The widget, logging, and editor-stub path variables establish frontend defaults, so an
explicit matching TOML value wins. The package-root variable selects Native's package store because
the managed package root is not a normal TOML setting.

Normal users should prefer the Native defaults or explicit config values. These bootstrap keys exist
primarily so multiple EasyBarKit frontends can stay isolated without duplicating the shared parser.

## Reload

```bash
easybar-native config reload
```

Validate a specific file through the running Native app:

```bash
easybar-native config validate --config ~/.config/easybar-native/config.toml
```
