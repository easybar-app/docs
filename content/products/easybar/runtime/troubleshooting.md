# Troubleshooting

Start with the symptom below. EasyBar keeps the main app, Lua runtime, package store, and permission-sensitive agents separate, so identifying the affected layer usually narrows the problem quickly.

## Collect basic status

```bash
pgrep -fl '/EasyBar$'
pgrep -fl EasyBarLuaRuntime
pgrep -fl EasyBarCalendarAgent
pgrep -fl EasyBarNetworkAgent
brew services list | grep easybar
easybar refresh
```

`easybar refresh` confirms that the CLI can reach the main control socket. Use `easybar metrics` for a runtime and connection snapshot, and `easybar agent version all` to compare the running helper versions.

## Find the logs

Enable retained debug logs if necessary:

```toml
[logging]
enabled = true
level = "debug"
directory = "~/.local/state/easybar"
```

The default process logs are:

```text
~/.local/state/easybar/easybar.out
~/.local/state/easybar/calendar-agent.out
~/.local/state/easybar/network-agent.out
```

Use `easybar logs --follow` when you need live records. See [Logs](../../../cli/easybar/logs.md) and [Logging Configuration](../configuration/logging.md).

## Bar does not appear

1. Confirm `/Applications/EasyBar.app` exists.
2. Start it with `open -a EasyBar`.
3. Check `easybar.out` for config, lock, screen, font, and Lua startup errors.
4. Confirm another EasyBar build is not holding the single-instance lock.
5. If Gatekeeper blocks a manual install, follow [macOS Quarantine](../installation.md#macos-quarantine).

## Config changes do not apply

When `watch_config = false`, reload manually:

```bash
easybar config reload
```

A rejected reload leaves the last valid configuration active. Validate the file and inspect the reported key or section:

```bash
easybar config validate --config ~/.config/easybar/config.toml
```

## Calendar is empty

Calendar data requires the calendar agent and macOS Calendar permission. Check the service, grant access, then restart the agent after a permission change:

```bash
brew services list | grep easybar-calendar-agent
easybar agent restart calendar
```

Also check calendar include/exclude filters when only some calendars are missing. For socket probes, raw responses, and unresponsive-service recovery, use [Agent Diagnostics](agent-diagnostics.md).

## Wi-Fi or network data is empty

Wi-Fi and network data require the network agent. Wi-Fi identity fields additionally require Location Services permission.

After changing Location permission:

```bash
easybar agent restart network
```

If only selected fields are missing, verify the configured Wi-Fi fields and compare them with the raw agent response in [Agent Diagnostics](agent-diagnostics.md).

## AeroSpace widgets do not update

EasyBar requires AeroSpace 0.21.0 or newer:

```bash
aerospace --version
```

The CLI and running AeroSpace.app server should both meet that requirement. After an AeroSpace update, restart AeroSpace.app if their versions differ.

With EasyBar logging at `debug`, useful messages include:

```text
aerospace subscription started
aerospace subscription event received
aerospace subscription disconnected
aerospace subscription reconnect scheduled
```

EasyBar reconnects automatically when AeroSpace becomes available again. Trigger an immediate state refresh with:

```bash
easybar refresh
```

A local automation that already knows workspace state changed can emit a scripting event through [Runtime Control](control.md#scripting-events).

## Lua widget fails to load

Loader errors identify the widget source and failing API call in `easybar.out`. Check that:

- a manual widget is below the configured `widgets_dir`, or the installed package is active in the managed package store;
- reusable manual modules are below `<widgets_dir>/shared` and installed package modules are declared exports;
- file-backed assets are included with the widget or package;
- interval properties include the required callback;
- external commands are available through `[app.env].PATH`.

Validate config separately from Lua source:

```bash
easybar config validate
```

After fixing widget code, restart only Lua:

```bash
easybar runtime restart
```

For package installation problems, see [Install And Manage](../../../widget-store/manage.md). For authoring issues, see [Commands](../../../lua/guides/commands.md), [Reusable Modules](../../../lua/guides/modules.md), and [Lua Logging](../../../lua/guides/logging.md).

## Widget stops updating or a command is stuck

First request a normal refresh:

```bash
easybar refresh
```

If only Lua is stale, use `easybar runtime restart`. Asynchronous commands should have bounded timeouts, and long-running user actions should expose cancellation when practical. Inspect widget-specific logs before restarting when the failed operation itself is important to diagnose.

## Popup or context menu does not open

Hover popups and native context menus use different interactions:

- hovering the widget anchor presents its popup;
- right-clicking the anchor presents the widget's native context menu when configured;
- right-clicking empty bar space presents EasyBar's application menu;
- right-clicking popup content targets the popup, not its anchor.

If a hover popup covers the anchor, move back to the actual bar icon before right-clicking. See [Popups](../../../lua/guides/popups.md) and [Native Context Menus](../../../lua/guides/context-menus.md).

## Homebrew install or upgrade fails

Run the failing Homebrew operation directly in a terminal to distinguish package-manager output from EasyBar presentation:

```bash
brew update
brew upgrade --cask easybar-app/tap/easybar
```

Homebrew installations handle quarantine for the app, CLI, and agent applications. Manual release-archive installs do not. Preserve the complete Homebrew error before changing extended attributes.

## Another instance is already running

EasyBar uses a single-instance guard. Stop the installed app before launching a development build:

```bash
pkill -x EasyBar
```

The separately managed agent services do not count as duplicate EasyBar instances.

## Full reset

Use a full app reset only after the narrower actions above fail:

```bash
pkill -x EasyBar || true
open -a EasyBar
```

Do not kill responsive helper agents just to reset the bar. Restart them individually with `easybar agent restart ...`, or use the Homebrew service commands from [Agent Diagnostics](agent-diagnostics.md) when their sockets are unavailable.

## Escalation checklist

When reporting a problem, include:

- EasyBar version from `easybar --version`;
- macOS and AeroSpace versions when relevant;
- installation method;
- the affected widget or process;
- the smallest relevant log excerpt;
- whether `easybar refresh` and `easybar config validate` succeed.

Do not include access tokens, private URLs, calendar content, or other secrets from widget command output.

## Related pages

- [Runtime Control](control.md)
- [Agent Diagnostics](agent-diagnostics.md)
- [CLI Reference](../../../cli/easybar/index.md)
- [macOS Quarantine](../installation.md#macos-quarantine)
