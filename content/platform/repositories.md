# Repositories

The EasyBar project family is split by ownership:

| Repository                   | Owns                                                                                                                         |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `easybar-app/easybar-kit`    | Shared Swift/Lua runtime, shared UI/runtime behavior, package manager, CLI core, helper-agent products, schemas, generators. |
| `easybar-app/easybar`        | Custom full-width bar frontend and EasyBar-specific packaging/release behavior.                                              |
| `easybar-app/easybar-native` | Native `NSStatusItem` frontend, `easybar-native` launcher, Native packaging/release behavior.                                |
| `easybar-app/widgets`        | Independently versioned Lua widgets and libraries.                                                                           |
| `easybar-app/registry`       | Published package versions, archive URLs, and checksums.                                                                     |
| `easybar-app/docs`           | Hand-written easybar.dev content and generated-reference assembly.                                                           |

The split is deliberately asymmetric. EasyBarKit contains more code because it is the shared
implementation layer; the frontend repositories should stay focused on where and how shared surfaces
are presented.

See [Architectural Boundaries](../internals/architecture/boundaries.md) for contributor placement
rules.
