# Architectural Boundaries

The repository split is an ownership boundary, not several copies of the same application.

## Frontends own presentation and defaults

- `easybar` owns custom full-width panel/window geometry and EasyBar-specific packaging;
- `easybar-native` owns `NSStatusItem` creation, sizing, ordering, Native-specific bootstrap paths,
  its public CLI launcher, and Native packaging.

A frontend should not fork Lua parsing, package validation, node rendering, or IPC behavior just to
change where a surface appears.

## EasyBarKit owns shared behavior

Put shared config, Lua, package, rendering, interaction, Inbox, event, and transport behavior in
EasyBarKit. Frontends supply policy and identity instead of copying the implementation.

The current public widget rule is:

> Lua is the portable extension model. Swift/AppKit is an internal host implementation.

EasyBar may still expose product-owned native built-ins. EasyBar Native intentionally does not turn
that complete built-in set into a second public plugin model.

## Mutable state belongs to a frontend

Sharing EasyBarKit must not imply sharing:

- config files;
- runtime/control sockets;
- manual widget directories;
- package databases or activation links;
- log roots;
- CLI names.

That state is selected by the frontend profile.

## Agents belong to the EasyBar product boundary

Calendar and Network agents remain reusable EasyBarKit products and typed protocols, but EasyBar
Native does not depend on them. The full EasyBar product owns their installation and user-facing
management because its native built-ins consume them.

Independent projects may reuse an agent core or protocol without changing the Native installation
contract.

## CLI boundary

`EasyBarCtl` is a shared implementation core. `easybar` and `easybar-native` provide different
user-facing profiles over it. Do not duplicate the package manager or IPC parser in the Native repo.

## How to choose an owner

- shared runtime, Lua, rendering, package, config, event, or IPC behavior → `easybar-kit`;
- cross-process value/protocol used by several targets → `EasyBarShared`;
- full-width custom-bar presentation → `easybar`;
- status-item presentation or Native bootstrap/launcher behavior → `easybar-native`;
- EasyBar Calendar/Network collection → corresponding agent/core target;
- independently versioned Lua integration → `widgets`;
- package release metadata/checksums → `registry`;
- public/contributor documentation → `docs`.
