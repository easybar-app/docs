# Platform

The public apps are intentionally small frontends over a shared implementation. This section names
the platform pieces so product documentation does not blur ownership boundaries.

```text
easybar-kit      shared Swift/Lua implementation and reusable executable products
easybar          full-width custom-bar frontend
easybar-native   isolated NSStatusItem frontend
widgets          independently versioned Lua packages
registry         immutable release metadata and checksums
docs             easybar.dev source and generated-reference assembly
```

## Shared does not mean global state

EasyBar and EasyBar Native both depend on EasyBarKit, but each frontend owns its own config, runtime
socket, package store, manual widget directory, log root, and public CLI name.

The Calendar and Network helper agents are EasyBar services, not prerequisites for EasyBar Native.
Their protocols and core libraries can still be reused by independent tools without making those
tools part of the Native runtime.

Continue with [EasyBarKit](easybar-kit.md), [Helper Agents](helper-agents.md), or
[Repositories](repositories.md).
