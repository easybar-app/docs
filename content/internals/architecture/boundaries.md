# Architectural Boundaries

The repository split is an ownership boundary, not three copies of the same application.

## Keep presentation in the frontend

Frontend code decides where shared widget surfaces live:

- `easybar` owns the custom full-width panel and bar geometry;
- `easybar-native` owns `NSStatusItem` creation, sizing, ordering, and lifecycle.

Do not copy config parsing, Lua supervision, built-in widget logic, popup behavior, or package
management into a frontend. Those belong in EasyBarKit.

## Keep shared UI/runtime behavior in EasyBarKit

EasyBarKit decides how shared widget state becomes SwiftUI widget content and how interactions are
routed. Examples:

- good: the network agent returns RSSI, EasyBarKit maps it to Wi-Fi bars;
- good: the calendar agent returns normalized event data, EasyBarKit builds calendar presentation
  state;
- good: a frontend places the resulting widget surface in a panel or `NSStatusItem`;
- avoid: each frontend implements its own Wi-Fi, calendar, Lua, or package logic.

## Keep permission ownership in agents

If a feature depends on permission-sensitive system APIs, keep collection or mutation in the
relevant agent when practical. Agents return typed data; they do not choose frontend layout.

## Keep cross-process protocols typed

If two processes exchange data, define request and response models explicitly in shared code. Avoid
parallel ad-hoc protocols in each frontend.

## Keep the CLI thin

The `easybar` CLI is built from EasyBarKit and communicates with a selected running frontend or
helper agent. It should not duplicate runtime behavior.

## Keep Lua transport simple

The Lua boundary remains inspectable:

- JSON in;
- JSON out;
- stderr/log records for diagnostics.

Package manifests target the EasyBarKit API contract. They do not declare compatibility with one
frontend executable.

## How to choose an owner

- shared config, runtime, widget, menu, popup, package, event, or Lua behavior → `EasyBarKit`;
- process-boundary values or protocols used by several targets → `EasyBarShared`;
- custom-bar-only window/layout behavior → `easybar`;
- status-item-only behavior → `easybar-native`;
- calendar collection/mutation → `EasyBarCalendarCore` / calendar agent;
- network collection → `EasyBarNetworkAgentCore` / network agent;
- independently versioned Lua integration → `widgets`.
