# CLI Core

EasyBarKit's `EasyBarCtl` target is the shared command-line implementation behind two public commands:

```text
easybar         → EasyBar profile
easybar-native  → EasyBar Native profile → bundled EasyBarCtl core
```

The public commands deliberately share parsing, IPC, package management, output formatting, and
validation behavior while selecting different runtime ownership.

## Frontend profile

A CLI profile supplies at least:

- user-facing command name and display name;
- whether helper-agent commands are available;
- config/runtime/widget/package/log/editor-stub defaults inherited through bootstrap environment.

`easybar` uses the normal EasyBar paths and exposes the agent command group. `easybar-native` uses
Native paths and hides helper-agent management.

## Responsibilities

The CLI core:

- resolves command paths and command-specific options;
- maps frontend commands to typed `IPC.Command` requests;
- connects to the selected frontend control socket;
- manages package search/install/update/uninstall against the selected package root;
- reads and filters process logs;
- renders metrics and Inbox results;
- exposes agent-specific operations only when the profile supports them.

The CLI remains a transport/package client. Runtime behavior stays in EasyBarKit services rather
than being reimplemented in command handlers.

## Public commands

See [`easybar`](../../cli/easybar.md) and [`easybar-native`](../../cli/easybar-native.md) for the
user-facing command contracts.
