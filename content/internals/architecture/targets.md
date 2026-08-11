# Targets

Swift targets are split between EasyBarKit and the two frontend repositories.

## EasyBarKit targets

| Target                        | Responsibility                                                                                        |
| ----------------------------- | ----------------------------------------------------------------------------------------------------- |
| `EasyBarKit`                  | Shared app runtime, presentation model, Lua/node rendering, Inbox, events, themes, and orchestration. |
| `EasyBarShared`               | Cross-process models, paths, logging, IPC contracts, and bootstrap keys.                              |
| `EasyBarConfigSchema`         | Shared configuration schema metadata.                                                                 |
| `EasyBarCalendarConfig`       | Calendar configuration parsing/editing helpers.                                                       |
| `EasyBarCalendarCore`         | EventKit collection/mutation logic used by the Calendar agent.                                        |
| `CEasyBarEventKitBridge`      | Objective-C exception boundary for EventKit travel-time access.                                       |
| `EasyBarCalendarPresentation` | Calendar request/presentation helpers.                                                                |
| `EasyBarCalendarUI`           | Reusable Calendar SwiftUI components.                                                                 |
| `EasyBarNetworkAgentCore`     | Reusable Network agent logic.                                                                         |
| `EasyBarCtl`                  | Shared CLI implementation used directly by EasyBar and privately by EasyBar Native.                   |
| `EasyBarLuaRuntime`           | Out-of-process Lua runtime launcher.                                                                  |
| `EasyBarCalendarAgent`        | Calendar-agent executable.                                                                            |
| `EasyBarNetworkAgent`         | Network-agent executable.                                                                             |
| `EasyBarGenerateConfig`       | Config reference/default generator.                                                                   |
| `EasyBarGenerateBuildInfo`    | Build-info generator used by the SwiftPM plugin.                                                      |

## EasyBar frontend

`easybar` contains `EasyBarApp`, which owns the full-width bar window, geometry, surface layout, and
EasyBar packaging. It imports EasyBarKit rather than implementing another runtime.

## EasyBar Native frontend

`easybar-native` contains two executable targets:

- `EasyBarNativeApp` — app entrypoint and `NSStatusItem` surface controller;
- `EasyBarNativeCtl` — small public `easybar-native` launcher that selects Native's isolated profile
  and invokes the bundled EasyBarKit CLI core.

The Native app requests only the host-owned Inbox built-in surface; ordinary visible status items are
Lua widget roots.

## Target rule

Put code in the narrowest owner. Frontend targets should stay small; shared behavior belongs in
EasyBarKit unless it is genuinely specific to one presentation or distribution contract.
