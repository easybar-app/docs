# EasyBarKit

EasyBarKit is the shared implementation layer behind the EasyBar frontends. It is primarily a Swift
Package dependency and source of reusable executable products rather than a third menu-bar frontend.

## Responsibilities

EasyBarKit owns shared behavior such as:

- configuration parsing and schema generation;
- Lua process supervision, transport, events, commands, timers, storage, and rendering;
- SwiftUI node views, popups, context menus, themes, and Inbox;
- package validation, dependency resolution, activation, and registry clients;
- control-socket and logging infrastructure;
- the shared CLI implementation used by `easybar` and `easybar-native`;
- reusable Calendar and Network agent products used by EasyBar.

## Frontend profiles

A frontend supplies its identity and defaults to EasyBarKit. That profile decides presentation policy
and user-data ownership without duplicating the runtime.

EasyBar enables the complete host-owned built-in surface set. EasyBar Native enables only the
host-owned Inbox surface and supplies Native-specific config, widget, package, runtime, log, and
editor-stub defaults.

## Public extension contract

Lua packages target `minimum_easybar_kit_version`. They do not need separate package formats for the
two frontends. Frontend-specific requirements should be exceptional and documented by the package.

For implementation details, see [Architecture](../internals/architecture/overview.md) and
[Targets](../internals/architecture/targets.md).
