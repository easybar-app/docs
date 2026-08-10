# Widget Packages

EasyBar can install a package by its registry name, from a local directory, or from a direct archive. The [official registry](https://github.com/easybar-app/registry) is a metadata-only catalog for discovery and dependency resolution; package source and release archives remain in their owning repositories. A package does not need to be published in a registry.

## Install an official package

Use a bare package name to resolve the latest immutable release from the official registry. Source for the official packages lives in the separate [widgets repository](https://github.com/easybar-app/widgets):

```bash
easybar widgets install PACKAGE_NAME
easybar config reload
```

Registry releases contain a versioned archive URL and SHA-256. EasyBar verifies the digest before extracting the archive. Dependencies such as the official `shared` library are installed automatically from the registry when they are not already present at a compatible version.

Installing an already installed package is an error. Use `widgets update` for a normal registry
upgrade, or explicitly replace a package from any supported source with:

```bash
easybar widgets install PACKAGE_NAME --force
```

Every install is prepared inside that package's versioned store before it becomes active. A forced
install uses the same staged path and can therefore reinstall the currently installed version as
well as replace it with another version. See [Atomic installs and updates](#atomic-installs-and-updates)
for the exact filesystem behavior.

Use another registry index when needed:

```bash
easybar widgets install my-widget --registry https://example.com/easybar/index.json
```

The registry index may also be a local `index.json` path.

## Search a registry

List every package in the official registry or filter by name, description, kind, or category:

```bash
easybar widgets search
easybar widgets search QUERY
```

Search another remote or local registry with the same source syntax used by installation:

```bash
easybar widgets search QUERY --registry https://example.com/easybar/index.json
```

The live search results are the package catalog; the documentation does not maintain a duplicate
list.

## List installed packages

Read the local package database and show every installed widget and library with its version:

```bash
easybar widgets installed
```

Filter by package kind or request machine-readable output:

```bash
easybar widgets installed --widgets-only
easybar widgets installed --libraries-only
easybar widgets installed --json
```

This command is offline and reports the versions recorded in
`~/.local/share/easybar/packages/installed.json`.

## Check for and install updates

List newer registry releases for installed packages without changing anything:

```bash
easybar widgets outdated
```

Update one package or every outdated package, then reload EasyBar:

```bash
easybar widgets update PACKAGE_NAME
easybar widgets update --all
easybar config reload
```

A named update changes nothing when the selected registry does not contain a newer version. When a
newer version exists, EasyBar downloads and validates it into a staged store directory, commits the
new version, then atomically switches the package's active symlink. The previous successfully
installed versions remain in the store until retention pruning runs.

Pass `--registry` to any of these commands to use another remote or local registry. Updates only
apply to packages whose recorded installation source matches a release in that registry. Locally
created packages and packages installed from unrelated archives are never replaced by `update
--all`.

`update --all` processes outdated packages one at a time. A package that commits successfully stays
updated even if a later package update fails.

## Install a self-created package

Use the [EasyBar widget template](https://github.com/easybar-app/widget-template) for a standalone,
release-ready widget repository. A local package only needs a `package.toml`; it does not need a Git
repository or registry entry:

```bash
easybar widgets install ./my-widget --no-registry
```

The minimum widget manifest is:

```toml
manifest_version = 1
name = "my-widget"
version = "0.1.0"
kind = "widget"
entrypoint = "widget.lua"
```

A reusable Lua library declares exports instead of an entrypoint:

```toml
manifest_version = 1
name = "retry-kit"
version = "1.0.0"
kind = "library"

[exports]
retry = "retry.lua"
```

Install the library and use the normal local Lua binding in a widget:

```lua
local retry = require("retry")
```

Dependencies are package names with exact or caret constraints:

```toml
[dependencies]
retry-kit = "^1.0.0"
```

With `--no-registry`, each dependency must already be installed. Without that option, EasyBar checks installed packages first and asks the selected registry only for missing or incompatible dependencies. This lets private packages depend on other private packages without publishing either one: install the library first, then the widget.

## Install an archive directly

Local archives may be installed by path:

```bash
easybar widgets install ./my-widget-0.1.0.tar.gz
```

A remote archive requires an explicit SHA-256:

```bash
easybar widgets install \
  https://example.com/my-widget-0.1.0.tar.gz \
  --sha256 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

The archive must place `package.toml` at its root. Symbolic links, absolute paths, and parent-directory traversal are rejected.

## Managed package layout

All packages install into EasyBar's managed data directory, whether they come from the official registry, another registry, a local directory, or an archive:

```text
~/.local/share/easybar/packages/
├── installed.json
├── store/
│   └── <name>/
│       ├── <active-version>/
│       │   ├── .easybar/
│       │   │   └── source/
│       │   ├── package.toml
│       │   └── ...activated widget projection...
│       ├── <previous-version>/
│       └── <older-previous-version>/
└── active/
    ├── <widget-name> -> ../store/<widget-name>/<active-version>
    └── shared/
        └── <module>.lua -> .../store/<package>/<active-version>/.easybar/source/<file>.lua
```

`store/<name>/<version>/` is the committed version. For widgets, its visible root contains the
entrypoint, non-Lua assets, package metadata, and other files safe for runtime discovery. The complete
package source is retained below `.easybar/source/` and is not scanned as widget code.

`active/<widget-name>` is a relative symbolic link to the committed widget version. Declared package
exports are relative symbolic links below `active/shared/` that point into the committed version's
`.easybar/source/` tree. EasyBar loads this activation tree in addition to the manual
`[app].widgets_dir`.

The configured `widgets_dir` is only for Lua files you manage yourself. Package installation does
not write to it or migrate package data from it. Only the current managed package layout is
supported.

## Atomic installs and updates

Before a package version is committed, EasyBar prepares it as:

```text
store/<name>/<version>.staging-<id>/
```

The staged directory contains the complete source snapshot and the runtime-safe activation
projection. Only after preparation succeeds does EasyBar rename it to the committed version path.

For a new version, the existing versions remain untouched while the new version is prepared and
committed. EasyBar then replaces the `active/<name>` symlink with a newly staged symlink that points
to the committed version.

A same-version `--force` install temporarily moves the existing committed version to:

```text
store/<name>/<version>.backup-<id>/
```

The staged replacement is then renamed to `<version>`, its activation links are switched, and
`installed.json` is written atomically. After the complete install succeeds, the temporary backup
is removed. If any committed filesystem change or database write fails, EasyBar rolls back the
package-local replacements and restores the previous paths.

Filesystem replacements are package-local. When one install also materializes dependencies, EasyBar
coordinates those per-package transactions and rolls them back together if the final package database
write fails. It does not copy or back up the complete managed package directory for an update.

## Version retention

After a successful install or update, EasyBar keeps at most three committed semantic versions for
each package:

- the currently active version
- the two most recently successfully activated previous versions

Older committed versions are removed after the new version and package database have committed.
Temporary `.staging-<id>` and `.backup-<id>` paths are transaction artifacts, not retained versions.

Reinstalling the same version with `--force` replaces that version in place. Its temporary backup is
kept only until the replacement commits successfully.

## Uninstall a package

Remove a package and all of its managed versions and active links with:

```bash
easybar widgets uninstall PACKAGE_NAME
easybar config reload
```

EasyBar refuses to remove a package while another installed package depends on it. Dependencies
that become unused are left installed so removal is always explicit. Manually managed files in
`[app].widgets_dir` are never removed.
