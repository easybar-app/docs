# Targets

Swift targets are split between `easybar-kit` and the two frontend repositories.

## EasyBarKit targets

`easybar-kit` exports the shared runtime and helper products:

| Target                        | Responsibility                                                                                                            |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `EasyBarKit`                  | Application runtime, presentation model, built-in/Lua widget rendering, popups, events, themes, inbox, and orchestration. |
| `EasyBarShared`               | Cross-process models, paths, logging, IPC contracts, and common utilities.                                                |
| `EasyBarConfigSchema`         | Shared configuration schema metadata.                                                                                     |
| `EasyBarCalendarConfig`       | Calendar configuration parsing and editing helpers.                                                                       |
| `EasyBarCalendarCore`         | Permission-sensitive EventKit collection and mutation logic used by the calendar agent.                                   |
| `CEasyBarEventKitBridge`      | Objective-C exception boundary for EventKit travel-time access.                                                           |
| `EasyBarCalendarPresentation` | Reusable calendar request and presentation helpers.                                                                       |
| `EasyBarCalendarUI`           | Reusable calendar SwiftUI components and composer state.                                                                  |
| `EasyBarNetworkAgentCore`     | Reusable network-agent logic.                                                                                             |
| `EasyBarCtl`                  | `easybar` command-line client and package-management commands.                                                            |
| `EasyBarLuaRuntime`           | Out-of-process Lua runtime host.                                                                                          |
| `EasyBarCalendarAgent`        | Calendar-agent executable entrypoint.                                                                                     |
| `EasyBarNetworkAgent`         | Network-agent executable entrypoint.                                                                                      |
| `EasyBarGenerateConfig`       | Configuration reference/default generator.                                                                                |
| `EasyBarGenerateBuildInfo`    | Build-info generator used by the SwiftPM plugin.                                                                          |

The corresponding source directories live under `easybar-kit/Sources/`.

## Custom-bar frontend

The `easybar` repository contains one executable target:

- `EasyBarApp` — app entrypoint, `BarPanel`, window controller, bar hosting view, frame layout, and
  left/center/right surface layout.

It imports `EasyBarKit` and `EasyBarShared`; it does not own a second runtime implementation.

## Native frontend

The `easybar-native` repository contains one executable target:

- `EasyBarNativeApp` — app entrypoint and `NSStatusItem` presentation controller.

It imports the same shared kit and renders the same top-level widget surfaces as native menu-bar
items.

## Target rule

Put code in the narrowest owner:

- shared runtime or widget behavior → `easybar-kit`;
- custom full-width bar behavior → `easybar`;
- native status-item behavior → `easybar-native`;
- permission-sensitive calendar/network collection → the corresponding agent/core target;
- public Lua integrations → `widgets` when they should be independently versioned.
