# Create & Contribute Packages

Use a package when a widget or Lua library should be installed, versioned, tested, and updated
independently from a user's manual `widgets_dir`.

EasyBar uses the same package format whether you publish a package from your own repository or
contribute it to the official widgets repository. The publishing workflow is different, so choose
that path first.

## Choose your path

| Goal                                          | Workflow                                                                                                                                                                                                                              |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Publish and maintain your own package         | Start from the [EasyBar widget template](https://github.com/easybar-app/widget-template), publish releases from your repository, and optionally submit the package to the registry.                                                   |
| Contribute to the official package collection | Fork the [official widgets repository](https://github.com/easybar-app/widgets), make the package change on a branch, and open a pull request against `easybar-app/widgets:main`. Maintainers publish the package release after merge. |

The package manifest and validation rules below apply to both paths.

## Package layout

In the official widgets repository, a typical widget package contains:

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

For a standalone package repository, use the current layout from the widget template rather than
copying the official monorepo directory structure unnecessarily.

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

Put focused Lua tests in `packages/<name>/tests/` when contributing to the official widgets
repository. The repository provides shared host implementations under `tests/support/` and also runs
a cross-package smoke test.

From the widgets repository, with EasyBar available as a sibling checkout:

```sh
make check
make lint-lua
make package PACKAGE=my-widget OUTPUT_DIR=dist
```

Use `EASYBAR_ROOT=/path/to/easybar` with `make check` when the app checkout is elsewhere. Inspecting
the generated archive before review is optional but useful.

Standalone package repositories should use the equivalent checks and release targets supplied by
the widget template.

## Publish your own package

For a package you maintain in your own repository:

1. start from the [EasyBar widget template](https://github.com/easybar-app/widget-template);
2. implement and test the package using the manifest rules on this page;
3. publish versioned releases from your repository using the template's release workflow;
4. keep future releases compatible with the dependency constraints you declare; and
5. submit the package to the EasyBar registry when you want it to be discoverable through the Widget Store.

Publishing from your own repository means you own the release tags and package lifecycle. The
registry is discovery metadata; it does not become the source repository for the package.

## Contribute to the official widgets repository

Use the normal GitHub fork and pull-request workflow. Contributors should not publish official
package releases directly.

1. Fork [`easybar-app/widgets`](https://github.com/easybar-app/widgets) on GitHub.
2. Clone your fork and create a branch for the package change.
3. Add or update the package below `packages/<name>/`.
4. Run the repository checks locally.
5. Commit the focused change and push the branch to your fork.
6. Open a pull request against `easybar-app/widgets:main`.
7. Address review feedback and keep the branch passing CI.

A typical local setup is:

```sh
git clone https://github.com/<your-user>/widgets.git
cd widgets
git remote add upstream https://github.com/easybar-app/widgets.git
git switch -c feat/my-widget
```

Before opening the pull request:

```sh
make check
make lint-lua
```

Do not create an official `*-v*` release tag as part of the contribution. After the pull request is
reviewed and merged, an EasyBar maintainer creates the package release.

For a new official package, publication in the widget registry is a separate review step. Later
releases of an already registered package are discovered by the registry automation. Package source
and release archives remain in the widgets repository; the registry stores metadata used for
discovery and dependency resolution.

## Pull request checklist

- The manifest name matches its directory.
- The declared entrypoint, exports, README, and assets exist.
- Every non-test Lua file is the entrypoint or an export.
- Dependencies use supported version constraints.
- External tools, permissions, settings, and authentication are documented.
- Focused tests cover parsing, state transitions, and actions where applicable.
- `make check` passes; run `make lint-lua` when StyLua is installed.
- Generated archives and checksums from `dist/` are not committed.
- The contribution does not create an official package release tag.

For installation behavior after publication, see [Install And Manage](manage.md).
