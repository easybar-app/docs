# EasyBar Native Quick Start

This guide installs EasyBar Native, adds one Lua package, and verifies that you are operating on the
Native frontend's isolated state.

## 1. Install and launch

```bash
brew tap easybar-app/tap
brew install --cask easybar-app/tap/easybar-native
open -a "EasyBar Native"
```

Confirm that the Native launcher is available:

```bash
easybar-native --version
```

## 2. Add a Lua widget

Install the official Caffeinate package into Native's package store:

```bash
easybar-native widgets install caffeinate
easybar-native config reload
```

A Caffeinate status item should appear in the normal macOS menu-bar area. The package uses the
system `/usr/bin/caffeinate` command and does not require an EasyBar helper agent.

Verify the installation when the item does not appear:

```bash
easybar-native widgets installed
easybar-native logs --runtime lua --level debug --follow
```

Leave the log command running and issue `easybar-native config reload` from another terminal to
capture a fresh load attempt.

## 3. Know which state you changed

The command above writes below:

```text
~/.local/share/easybar-native/packages
```

It does not install the package for EasyBar. To use the same package in both frontends, install it
again with `easybar widgets install caffeinate`.

## 4. Optional: add an Inbox publisher

Inbox is the one host-owned built-in in EasyBar Native. Lua packages can publish structured items
into it without creating a separate status icon for every source. For example:

```bash
easybar-native widgets install inbox-brew
easybar-native config reload
```

The package requires Homebrew in the configured command path. Other Inbox publishers may require
authentication through tools such as `gh` or `glab`; read the package page before installation.

## What Native intentionally does not add

EasyBar Native does not turn the shared configuration schema's battery, Wi-Fi, calendar, Spaces,
volume, CPU, or group sections into status items. Use Lua packages for custom Native items, or choose
[EasyBar](../easybar/index.md) when you want the complete native built-in set and full-width layout.

## Next steps

- [Lua Widgets & Packages](widgets.md)
- [Configuration & Paths](configuration.md)
- [Widget Store Catalog](../../widget-store/catalog.md)
- [`easybar-native` CLI](../../cli/easybar-native.md)
- [Troubleshooting](troubleshooting.md)
