# Create And Publish Packages

Use a package when a widget or Lua library should be installed, versioned, tested, and updated
independently from a user's manual `widgets_dir`.

For a new standalone project, start from the
[EasyBar widget template](https://github.com/easybar-app/widget-template). Contributions to the
[official widgets repository](https://github.com/easybar-app/widgets) use the same package model.

## Package layout

A typical widget package contains:

```text
packages/<name>/
├── package.toml
├── README.md
├── widget.lua
├── assets/
└── tests/
    └── test.lua
```

Only include directories the package needs. Tests live under `tests/` and are excluded from release
archives by the official widgets release tooling.

A package name should be lowercase and hyphen-separated.

## Widget manifest

A widget declares its entrypoint explicitly. The entrypoint is not required to be named
`widget.lua`; it may be any validated Lua path inside the package.

```toml
manifest_version = 1
name = "my-widget"
version = "0.1.0"
kind = "widget"
description = "Describe what the widget shows or controls."
license = "Apache-2.0"
minimum_easybar_version = "0.50.0"
entrypoint = "widget.lua"
readme = "README.md"
categories = ["utilities"]

[repository]
url = "https://github.com/easybar-app/widgets"
path = "packages/my-widget"
```

The package manager activates exactly the declared entrypoint. It does not recursively discover
other Lua files in the package.

Keep widget-owned assets inside the package and resolve them from the entrypoint with
`easybar.asset(...)`:

```lua
local icon = easybar.asset("assets/icon.svg")
```

For managed packages, `@/` resolves from the committed package root when package-root-relative access
is intentional.

## Library manifest

A reusable library sets `kind = "library"`, omits `entrypoint`, and declares its public modules:

```toml
manifest_version = 1
name = "my-library"
version = "1.0.0"
kind = "library"

[exports]
my_library = "my_library.lua"
```

Consumers load an export through normal Lua module resolution:

```lua
local library = require("my_library")
```

Export names may be namespaced. For example:

```toml
[exports]
"my_widget.policy" = "policy.lua"
```

Every non-test Lua file in an installable package must be either the widget entrypoint or a declared
export. This keeps executable package files explicit.

## Dependencies

Declare package dependencies with exact or caret semantic-version constraints:

```toml
[dependencies]
shared = "^0.1.0"
my-library = "^1.0.0"
```

The package manager resolves compatible installed versions first and uses the selected registry when
it needs another release. The official widgets CI also checks that the current official package set
does not require mutually incompatible versions of the same library.

## Requirements and settings

Declare external commands, optional environment variables, native-inbox use, and user-facing
settings in `package.toml` when the package needs them. Existing official package manifests are the
best source for the optional table shapes, and the generated [Catalog](catalog.md) exposes the
resulting metadata.

The package README should explain:

- what the package does;
- required external tools and authentication;
- permissions;
- widget settings;
- important operational behavior.

Do not include credentials or machine-specific secrets.

## Tests

Put focused Lua tests in `packages/<name>/tests/`. The official widgets repository provides shared
host implementations under `tests/support/` and also runs a cross-package smoke test.

From the widgets repository, with EasyBar available as a sibling checkout:

```sh
make check
make lint-lua
make package PACKAGE=my-widget OUTPUT_DIR=dist
```

Use `EASYBAR_ROOT=/path/to/easybar` with `make check` when the app checkout is elsewhere. Inspecting
the generated archive before review is optional but useful.

## Publish an official package

For the official widgets repository:

1. add or update the package under `packages/<name>/`;
2. run the package validation and tests;
3. merge the reviewed change;
4. create the package release;
5. add a new registry entry when the package is new.

Later releases of an existing registered package are discovered by the registry automation. Package
source and release archives remain in the widgets repository; the registry stores metadata used for
discovery and dependency resolution.

## Review checklist

- The manifest name matches its directory.
- The declared entrypoint, exports, README, and assets exist.
- Every non-test Lua file is the entrypoint or an export.
- Dependencies use supported version constraints.
- External tools, permissions, settings, and authentication are documented.
- Focused tests cover parsing, state transitions, and actions where applicable.
- `make check` passes; run `make lint-lua` when StyLua is installed.
- Generated archives and checksums from `dist/` are not committed.

For installation behavior after publication, see [Install And Manage](manage.md).
