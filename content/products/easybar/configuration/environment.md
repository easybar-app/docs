# Environment

Use `[app.env]` for environment variables that should be visible inside the Lua runtime and shell
commands launched by EasyBar widgets. EasyBar inherits the parent process environment and overlays
the configured values.

## Example

```toml
[app]
widgets_dir = "~/.config/easybar/widgets"
lua_path = "lua"
runtime_dir = "~/.local/state/easybar/runtime"

[app.env]
PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
TAILSCALE = "/usr/local/bin/tailscale"
```

## PATH behavior

EasyBar resolves `PATH` in this order:

1. if `[app.env]` does not contain `PATH`, EasyBar overlays the default shown below so GUI-launched sessions can find common tools;
2. if `[app.env]` sets `PATH = ""`, EasyBar does not add a `PATH` override;
3. if `[app.env]` sets a non-empty `PATH`, EasyBar overlays that exact value.

```text
/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

The empty-string behavior is special to `PATH`. Other `[app.env]` values may be empty and are still
passed as explicit environment overrides.

## Bootstrap environment overrides

EasyBarKit supports a small set of process-level path overrides. The full EasyBar frontend normally
uses the EasyBar defaults shown here; EasyBar Native uses the same keys to establish its own isolated
defaults.

| Variable                          | EasyBar purpose                                |
| --------------------------------- | ---------------------------------------------- |
| `EASYBAR_CONFIG_PATH`             | Select the runtime config file.                |
| `EASYBAR_RUNTIME_DIR`             | Override `[app].runtime_dir`.                  |
| `EASYBAR_WIDGETS_DIR`             | Set the fallback manual widget directory.      |
| `EASYBAR_WIDGET_PACKAGES_DIR`     | Select the managed package root.               |
| `EASYBAR_LOGGING_DIR`             | Set the fallback logging directory.            |
| `EASYBAR_WIDGET_EDITOR_STUB_PATH` | Set the fallback Lua editor-stub path.         |
| `EASYBAR_LOG_LEVEL`               | Temporarily override `[logging].level`.        |

The precedence depends on the key:

- `EASYBAR_CONFIG_PATH` selects the config file before parsing.
- `EASYBAR_RUNTIME_DIR` is a real runtime override and wins over `[app].runtime_dir`.
- `EASYBAR_LOG_LEVEL` wins over `[logging].level` for the current process.
- `EASYBAR_WIDGETS_DIR`, `EASYBAR_LOGGING_DIR`, and `EASYBAR_WIDGET_EDITOR_STUB_PATH` provide
  frontend defaults; explicit TOML values win.
- `EASYBAR_WIDGET_PACKAGES_DIR` selects the managed package root because that path is not a normal
  user-facing TOML setting.

`EASYBAR_RUNTIME_DIR` is also used by EasyBar's helper-agent path resolution so derived socket and
lock defaults stay consistent. Explicit `lua_socket_path`, `lock_dir`, or agent `socket_path` values
still override their derived defaults.

For the runtime directory, precedence is:

```text
EASYBAR_RUNTIME_DIR
→ app.runtime_dir
→ EasyBar default
```

EasyBar does not perform generic shell-style `$VARIABLE` expansion inside config values. Paths
support `~` expansion only.

## Why this matters

GUI-launched macOS apps do not normally inherit shell startup files such as `.zshrc`. Set `[app.env]`
when Lua widgets need tools such as `brew`, `tailscale`, `kubectl`, or custom scripts.

See [EasyBar Native Configuration](../../easybar-native/configuration.md) for the Native path profile.
