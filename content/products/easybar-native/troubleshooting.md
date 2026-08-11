# EasyBar Native Troubleshooting

Start by confirming that you are inspecting **Native's** paths and command, not EasyBar's.

## Basic status

```bash
pgrep -fl EasyBarNative
pgrep -fl EasyBarLuaRuntime
easybar-native --version
easybar-native metrics
```

## Logs

Enable file logging in `~/.config/easybar-native/config.toml`:

```toml
[logging]
enabled = true
level = "debug"
directory = "~/.local/state/easybar-native"
```

The main application log is:

```text
~/.local/state/easybar-native/easybar-native.out
```

Read retained logs with:

```bash
easybar-native logs
```

For Lua-specific live diagnostics, prefer an explicit runtime filter:

```bash
easybar-native logs --runtime lua --level trace --follow
```

## Widget is installed but not visible

Check Native's package database and activation root:

```bash
easybar-native widgets installed
ls -la ~/.local/share/easybar-native/packages/active
```

Then reload:

```bash
easybar-native config reload
```

A package installed with `easybar widgets install ...` belongs to EasyBar and will not appear in
EasyBar Native. Install it again with `easybar-native` when you want it in both frontends.

## Manual widget does not load

Confirm the file is below:

```text
~/.config/easybar-native/widgets
```

and inspect the Native log for loader or Lua errors. Files in `shared/` are modules and are not loaded
as widget entrypoints.

## Wrong config seems to be loading

Check:

```bash
echo "${EASYBAR_CONFIG_PATH-}"
```

Without an override, EasyBar Native uses:

```text
~/.config/easybar-native/config.toml
```

Use `easybar-native config validate` to confirm the running Native process and CLI resolve the same
configuration.

## Calendar, Wi-Fi, or other EasyBar built-ins are missing

That is expected. EasyBar Native does not register the regular EasyBar built-in surface set and does
not depend on the EasyBar Calendar or Network agents. Add the behavior as a Lua widget/package or use
a separate native menu-bar application when appropriate.

## Complete user-data reset

Quit EasyBar Native first, then remove only Native's directories:

```bash
rm -rf ~/.config/easybar-native
rm -rf ~/.local/share/easybar-native
rm -rf ~/.local/state/easybar-native
```

This does not change EasyBar's config, packages, logs, or agents.
