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
store, and activation state.

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
- package validation defines exposed files;
- the selected frontend store commits immutable version directories;
- `active/` selects entrypoints and exports;
- Lua executes only those selected entrypoints and modules.
