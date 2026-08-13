# Configuration

EasyBar starts with built-in defaults even when no custom config file exists. The default bar enables spaces, battery, Wi-Fi, and calendar. Create a config only when you want to change those defaults.

The normal config path is:

```text
~/.config/easybar/config.toml
```

Override it for one process with:

```bash
EASYBAR_CONFIG_PATH=/path/to/config.toml
```

For a first setup, start with [Quick Start](../quick-start.md).

## Start from an example

The EasyBarKit repository ships two useful starting points:

- `config.minimal.toml` is a small customization example. It keeps the default built-ins, groups battery and Wi-Fi, and enables Wi-Fi details.
- `config.defaults.toml` contains the complete current defaults and supported sections. The generated [Configuration Reference](reference.md) mirrors it when you need exact keys and values.

From a cloned EasyBarKit repository, copy the minimal example with:

```bash
mkdir -p ~/.config/easybar
cp config.minimal.toml ~/.config/easybar/config.toml
easybar config reload
```

You can also start with an empty file and add only the settings you want to override.

## What belongs in config

Use `config.toml` for stable user-facing behavior:

- app paths, runtime directory, and reload behavior
- environment variables visible to Lua widgets
- selected theme and theme overrides
- logging settings
- helper-agent sockets and behavior
- bar height and colors
- native built-in widgets and groups
- Lua-owned values below `[widgets.<name>]`

Use Lua only when you need custom logic that config cannot express. See [Built-ins, Widget Store, Or Lua](../choosing-widgets.md).

## Important sections

| Section               | Purpose                                                                |
| --------------------- | ---------------------------------------------------------------------- |
| `[app]`               | App paths, runtime directory, reload behavior, and Lua command limits. |
| `[app.env]`           | Environment variables visible to Lua widgets and their commands.       |
| `[theme]`             | Selected theme and custom theme directory.                             |
| `[theme.colors]`      | Optional semantic color overrides.                                     |
| `[logging]`           | Shared logging settings for EasyBar and helper agents.                 |
| `[agents.calendar]`   | Calendar helper-agent settings.                                        |
| `[agents.network]`    | Network helper-agent settings.                                         |
| `[bar]`               | Bar layout and appearance.                                             |
| `[builtins.*]`        | Native widget configuration.                                           |
| `[builtins.groups.*]` | Native widget groups.                                                  |
| `[widgets.<name>]`    | Free-form settings owned by Lua widgets.                               |

## Themes and overrides

Themes provide shared visual defaults while explicit config values still win:

```text
built-in app defaults
→ selected theme
→ [theme.colors] overrides
→ explicit [bar] and [builtins.*] values
→ Lua widget props
```

Example:

```toml
[theme]
name = "default"
themes_dir = "~/.config/easybar/themes"

[theme.colors]
accent = "#8aadf4"

[bar.colors]
background = "#090909"
```

Custom theme files live below the configured `themes_dir`; see [Themes](themes.md) for lookup rules and the theme file format.

## Where to go next

| Goal                                     | Page                                                      |
| ---------------------------------------- | --------------------------------------------------------- |
| Configure app paths and runtime behavior | [App Settings](app.md)                                    |
| Configure command environment            | [Environment](environment.md)                             |
| Choose or customize colors               | [Themes](themes.md)                                       |
| Configure native widgets                 | [Built-ins](builtins/index.md)                                  |
| Group native widgets                     | [Native Groups](builtins/native-groups.md)                         |
| Configure Lua-owned settings             | [Widget Settings for Lua](../../../lua/guides/storage.md) |
| Configure helper agents                  | [Agents](agents.md)                                       |
| Configure logging                        | [Logging](logging.md)                                     |
| Check every exact key and default        | [Configuration Reference](reference.md)                   |
| Control the running app                  | [Runtime Control](../runtime/control.md)                  |

