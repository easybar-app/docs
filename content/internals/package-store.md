# Package Store Internals

This page documents the shared package-manager implementation behind both frontend package stores.
User workflows belong in [Install And Manage](../widget-store/manage.md); package authoring belongs in
[Create & Contribute](../widget-store/create-and-contribute.md).

## Package contract

The store accepts manifest version 2 and expresses runtime compatibility with
`minimum_easybar_kit_version`. The manifest targets EasyBarKit rather than a frontend executable.

## Frontend-owned roots

The package layout is identical, but the root is selected by the frontend profile:

```text
EasyBar        ~/.local/share/easybar/packages/
EasyBar Native ~/.local/share/easybar-native/packages/
```

Each root contains:

```text
<package-root>/
├── installed.json
├── pins.json
├── store/
│   └── <name>/
│       ├── <active-version>/
│       ├── <previous-version>/
│       └── <older-previous-version>/
└── active/
    ├── <widget-name> -> ../store/<widget-name>/<version>/<entrypoint>
    └── shared/
        └── <module>.lua -> .../store/<package>/<version>/<export-file>.lua
```

Installing with `easybar` and installing with `easybar-native` therefore create independent database,
store, activation, and pin state.

## Pin policy

`pins.json` is a small versioned policy file containing package names whose installed versions must
not be changed by normal update operations. Keeping this policy separate from `installed.json` lets
pinning change without changing the installed-package database format.

`widgets outdated` still evaluates pinned packages so newer releases remain visible. Named updates
reject a pinned root package; bulk updates omit pinned roots. The update resolver also receives the
current pin set so an incompatible pinned dependency cannot be replaced indirectly while updating
another package. Explicit forced installation remains available and does not clear the pin.

Uninstall removes the package name from `pins.json` as part of the uninstall transaction.

## Registry loading and revalidation

Remote registry indexes use a persistent per-registry cache. Before package discovery or update
selection, EasyBarKit revalidates the selected HTTPS index with the server instead of relying on
URLSession's implicit response cache.

The cached state contains the last validated `index.json`, its HTTP `ETag` and `Last-Modified`
validators when supplied by the server, and a SHA-256 of the cached index. A later request sends
`If-None-Match` and `If-Modified-Since` only when the cached content still matches that SHA.

A `304 Not Modified` response reuses the validated cached index. A `200 OK` response validates the
new registry and atomically replaces the cached state. If cached content or metadata is inconsistent,
the validators are discarded and the registry is fetched unconditionally. Local registry files do
not use this HTTP cache and are read directly.

The registry repository does not publish its own ETag file or field. HTTP validators belong to the
server that delivers `index.json`; the registry continues to own only package metadata and immutable
release checksums.

## Activation boundary

Widget packages activate exactly one manifest-declared entrypoint. Library and widget exports
activate exactly their declared files below `active/shared/`. Lua never recursively scans committed
version directories.

## Transactions

A version is prepared in a package-local staging directory, validated, atomically committed to its
semantic-version path, then activated. Same-version forced replacement uses a temporary backup so a
failed commit can restore the previous version and activation links.

Dependency compatibility is resolved before activation. One frontend store selects one active
version per package name; incompatible constraints fail rather than creating ambiguous module
exports.

## Retention and uninstall

After successful activation, at most three committed semantic versions are retained per package: the
active version and two most recent previous versions. Uninstall removes that package's activation
links, committed versions, and database entry from the selected frontend store. It refuses removal
while another installed package depends on it.

Manual files under the selected frontend's `widgets_dir` are outside this system.

## Invariant

- registry metadata selects release candidates;
- `pins.json` constrains normal update selection and dependency replacement;
- package validation defines exposed files;
- the selected frontend store commits immutable version directories;
- `active/` selects entrypoints and exports;
- Lua executes only those selected entrypoints and modules.
