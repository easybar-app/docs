# Package Store Internals

This page documents the implementation boundary behind the public [Widget Store](../widget-store/overview.md).
It is for contributors changing package installation, activation, dependency handling, or Lua startup.

User-facing install and update commands belong in [Install And Manage](../widget-store/manage.md).
Package authoring belongs in [Create And Publish](../widget-store/creating-packages.md).

## Store layout

All managed packages use one data directory:

```text
~/.local/share/easybar/packages/
├── installed.json
├── store/
│   └── <name>/
│       ├── <active-version>/
│       │   ├── package.toml
│       │   └── ...exact validated package files...
│       ├── <previous-version>/
│       └── <older-previous-version>/
└── active/
    ├── <widget-name> -> ../store/<widget-name>/<version>/<entrypoint>
    └── shared/
        └── <module>.lua -> .../store/<package>/<version>/<export-file>.lua
```

A committed version directory is the validated package itself. There is no second source copy and no
runtime projection.

## Activation boundary

Widget packages activate exactly one manifest-declared entrypoint:

```text
active/<widget-name> -> store/<widget-name>/<version>/<entrypoint>
```

Library exports and widget exports activate exactly their declared files below `active/shared/`.
The Lua runtime never recursively scans a committed package directory.

This is the central boundary between the package manager and Lua runtime:

- the package manager decides which version and files are active;
- Lua loads top-level widget activation links and resolves modules from `active/shared/`;
- the package store itself is not a widget discovery root.

The runtime resolves a managed entrypoint link to its real store path before execution. That keeps
file-relative `easybar.asset(...)` resolution anchored to the package instead of the `active/`
directory. See [Widget Loading](lua-runtime/widget-loading.md) for the Lua-side flow.

## Install transaction

Before committing a version, EasyBar prepares the validated package as:

```text
store/<name>/<version>.staging-<id>/
```

After preparation succeeds, the staging directory is renamed to the committed semantic-version path.
Activation links are then replaced with links to the committed entrypoint and exports, and
`installed.json` is written atomically.

A new version does not modify previous committed versions while it is being prepared.

## Same-version replacement

A forced reinstall of the currently committed version temporarily moves the old version to:

```text
store/<name>/<version>.backup-<id>/
```

The staged replacement is committed at `<version>`, activation links are switched, and the package
database is written. The backup is removed only after the complete replacement succeeds.

If a committed filesystem change or package database write fails, EasyBar restores the package-local
paths and activation state from the transaction.

## Dependency transaction boundary

An install may materialize dependencies before the requested package. Each package uses its own
replacement transaction, while the higher-level install coordinates the resulting package database
write. If final installation cannot commit, package changes participating in that operation are
rolled back rather than leaving an installed database that disagrees with activation state.

Dependency compatibility is resolved before activation. The active graph uses one selected version
per package name; incompatible requirements must fail instead of creating ambiguous module exports.

## Version retention

After a successful install or update, EasyBar retains at most three committed semantic versions per
package:

- the active version;
- the two most recently successfully activated previous versions.

Older committed versions are pruned only after the new version and package database have committed.
`.staging-<id>` and `.backup-<id>` paths are temporary transaction artifacts, not retained releases.

## Uninstall

Uninstall is package-wide. It removes the package's activation links, committed versions, and
installed database entry as one managed operation.

A package cannot be uninstalled while another installed package depends on it. Dependencies that
become unused are intentionally left installed so removal remains explicit.

Manual files under `[app].widgets_dir` are outside this system and are never removed by package
operations.

## Contributor invariant

Keep the ownership split simple:

- registry metadata selects release candidates;
- package validation defines the files a release may expose;
- the package store commits immutable version directories;
- `active/` selects entrypoints and exports;
- Lua executes only those selected entrypoints and modules.

Do not make Lua infer package versions or recursively inspect `store/`. Do not make the package
manager rediscover widget entrypoints from filenames when `package.toml` already declares them.
