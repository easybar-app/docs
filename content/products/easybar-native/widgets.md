# Lua Widgets & Packages in EasyBar Native

Lua is the public widget extension model for EasyBar Native. The same EasyBarKit node, event,
command, storage, popup, context-menu, and package contracts are used by the full EasyBar frontend.

## Install a package

Search the shared registry:

```bash
easybar-native widgets search
```

Install into Native's isolated package store:

```bash
easybar-native widgets install tailscale
easybar-native config reload
```

The active package root is:

```text
~/.local/share/easybar-native/packages/active/
```

This is intentionally different from EasyBar's `~/.local/share/easybar/packages/active/`.

## Manual widgets

Put hand-written Lua files below:

```text
~/.config/easybar-native/widgets/
```

The same discovery and `shared/` module rules described in [Lua Widgets](../../lua/index.md) apply.

## Presentation rules

Each top-level Lua root becomes one macOS status item. Child nodes, groups, popups, and interactions
remain part of that root's rendered content.

`position` and `order` still produce deterministic relative ordering, but macOS ultimately owns the
system status area. EasyBar Native cannot provide the full-width left/center/right geometry of the
EasyBar frontend.

## Frontend capability differences

The Lua API surface is shared, but not every host data source exists in every frontend. EasyBar
Native does not provide the EasyBar Calendar or Network agents, so agent-backed events such as
`calendar_change`, `wifi_change`, and `network_change` should not be the only refresh mechanism for a
Native-targeted widget. Prefer portable triggers such as `forced`, intervals, wake events, or direct
command integration when the data source can be queried without an EasyBar agent.

A package can still be installed in Native when it degrades gracefully without an EasyBar-only
capability. Package documentation should call out any functionality that is specific to one frontend.

## Host-owned Inbox

Inbox is the one host-owned built-in surface intentionally available in Native. Inbox publisher
packages do not create a second status icon for their source; they publish into the shared Inbox
surface.

For example:

```bash
easybar-native widgets install inbox-github
easybar-native widgets install inbox-gitlab
easybar-native widgets install inbox-brew
```

The packages and Inbox state remain Native-local because the package root and runtime directory are
Native-local.

## Portability

Package manifests target `minimum_easybar_kit_version`, not a specific frontend executable. A package
is generally portable between EasyBar and EasyBar Native when it only uses the shared Lua contract.
A package that assumes an EasyBar-only built-in or agent-backed capability should document that
frontend requirement explicitly.
