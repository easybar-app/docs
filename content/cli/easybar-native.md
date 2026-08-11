# `easybar-native` CLI

`easybar-native` controls EasyBar Native and manages its isolated Lua package store. It uses the same
EasyBarKit CLI core as `easybar`, but the launcher supplies Native-specific paths and does not expose
EasyBar helper-agent commands.

## Default ownership

```text
config    ~/.config/easybar-native/config.toml
runtime   ~/.local/state/easybar-native/runtime
logs      ~/.local/state/easybar-native
packages  ~/.local/share/easybar-native/packages
widgets   ~/.config/easybar-native/widgets
```

## Common commands

```bash
easybar-native refresh
easybar-native config reload
easybar-native config validate
easybar-native runtime restart
easybar-native metrics
easybar-native logs
easybar-native inbox list
easybar-native widgets search
easybar-native widgets install PACKAGE
easybar-native widgets installed
easybar-native widgets outdated
easybar-native widgets update --all
easybar-native widgets uninstall PACKAGE
```

Run command-specific help normally:

```bash
easybar-native --help
easybar-native widgets --help
easybar-native widgets install --help
```

## No helper-agent command group

EasyBar Native does not install or manage the EasyBar Calendar or Network agents, so commands such as
these belong only to `easybar`:

```text
easybar agent restart calendar
easybar agent restart network
easybar agent version all
```

Use the [EasyBar CLI](easybar.md) when you are diagnosing those services.

## Package operations are Native-local

```bash
easybar-native widgets install tailscale
```

writes below `~/.local/share/easybar-native/packages`. It does not activate the package for EasyBar.
See [Lua Widgets & Packages](../products/easybar-native/widgets.md) and [Install And Manage Packages](../widget-store/manage.md).

## Config and runtime operations

`easybar-native config reload`, `refresh`, `runtime restart`, Inbox commands, and metrics use the
Native control socket below `~/.local/state/easybar-native/runtime` unless explicitly overridden.

The public command name is a small launcher bundled with `EasyBarNative.app`; the shared EasyBarKit
CLI core remains an implementation detail.
