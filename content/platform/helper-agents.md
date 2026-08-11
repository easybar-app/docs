# Helper Agents

EasyBarKit provides two permission-sensitive helper products used by the full EasyBar frontend:

- `EasyBarCalendarAgent` for EventKit access and calendar mutations;
- `EasyBarNetworkAgent` for Wi-Fi and network observation.

Homebrew installs them as separately supervised services for EasyBar. The `easybar` CLI can query or
restart them through their local Unix sockets.

## EasyBar Native boundary

EasyBar Native does not install, start, stop, configure, or require these agents. Its normal package,
config, logging, and runtime paths are isolated from EasyBar.

This boundary keeps a minimal Native install from gaining background services or macOS permissions it
may never use.

## Reuse outside EasyBar

The agent cores and protocols remain reusable implementation pieces. An independent application can
reuse a protocol or core library without becoming an EasyBar Native dependency. That kind of
integration should be documented with the consuming standalone project rather than by adding the
service back to Native's installation contract.

For EasyBar user configuration, see [Agents](../products/easybar/configuration/agents.md). For
protocol details, see [Agent Internals](../internals/agents/overview.md).
