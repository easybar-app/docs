# Quick Start

This is the shortest path from a fresh install to a working EasyBar setup.

EasyBar can start without a custom config. The built-in defaults already show a useful bar with
spaces, battery, Wi-Fi, and calendar enabled. Create `config.toml` only when you want to customize
the bar.

## 1. Install EasyBar

Add the Homebrew tap and install EasyBar:

```bash
brew tap easybar-app/tap
brew install --cask easybar-app/tap/easybar
```

The cask installs the app and CLI and starts the separately managed calendar and network agent
services. [Installation](installation.md) explains upgrades, uninstall behavior, and the component
lifecycle.

## 2. Start EasyBar

Open the app from Finder, Spotlight, or the command line:

```bash
open -a EasyBar
```

The agents provide permission-sensitive calendar and network data. macOS asks for Calendar and
Location permissions on behalf of the corresponding agent. EasyBar can still start without those
permissions, but the related widget may show empty or denied data until access is granted.

The controller icon in the macOS menu bar can stop or restart the bar, reload configuration, restart
helper agents, and open EasyBar directories. It remains available when only the bar runtime is
stopped.

## 3. Verify the bar responds

```bash
easybar refresh
```

If this fails or the bar does not appear, follow the matching symptom in
[Troubleshooting](../runtime/troubleshooting.md).

## 4. Optional: create a custom config

EasyBar reads custom config from:

```text
~/.config/easybar/config.toml
```

The repository includes `config.minimal.toml` as a small starter override. From a cloned checkout:

```bash
mkdir -p ~/.config/easybar
cp config.minimal.toml ~/.config/easybar/config.toml
easybar config reload
```

See [Configuration](../configuration/overview.md) for the starter files and config path.

## 5. Customize built-ins first

The default bar already enables spaces, battery, Wi-Fi, and calendar. Configure native built-ins
before replacing platform integrations with Lua.

For example:

```toml
[builtins.time]
enabled = true

[builtins.date]
enabled = true

[builtins.volume]
enabled = true
```

Reload after editing:

```bash
easybar config reload
```

Use [Built-ins](../configuration/builtins.md) for widget behavior and
[Native Groups](../configuration/native-groups.md) when several built-ins should share one visual
container.

## 6. Install a ready-made widget when one exists

Search the Widget Store before writing a service integration yourself:

```bash
easybar widgets search
easybar widgets install PACKAGE_NAME
easybar config reload
```

Browse the [Widget Store](../widget-store/overview.md) to see official packages, installation
sources, updates, dependencies, and package creation.

## 7. Write Lua for custom behavior

Use manual Lua when you need behavior that is not already covered by a built-in or store package:
custom text, local scripts, project-specific status, bespoke click handling, or unique popup content.

Create the directory if needed:

```bash
mkdir -p ~/.config/easybar/widgets
```

Then follow [First Widget](../lua/guides/first-widget.md).

## 8. Use references when needed

- [Configuration Reference](../configuration/reference.md) for exact config keys and defaults.
- [Widget Store Catalog](../widget-store/catalog.md) for ready-made packages.
- [Lua Reference](../lua/reference/index.md) for exact Lua API shapes.
- [CLI Reference](../runtime/cli.md) for control and diagnostic commands.
