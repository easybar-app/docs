# Widget Store

The Widget Store is the shared package ecosystem for EasyBarKit Lua widgets and libraries. Package
metadata is frontend-neutral, while installation state belongs to the frontend command you use.

## Choose the destination frontend

Use `easybar` to install into EasyBar:

```bash
easybar widgets search
easybar widgets install PACKAGE_NAME
easybar config reload
```

Use `easybar-native` to install into EasyBar Native:

```bash
easybar-native widgets search
easybar-native widgets install PACKAGE_NAME
easybar-native config reload
```

The two commands use different managed roots:

```text
EasyBar        ~/.local/share/easybar/packages
EasyBar Native ~/.local/share/easybar-native/packages
```

Installing a package in one frontend does not activate it in the other.

## How the store fits together

The ecosystem separates three concerns:

- **packages** contain versioned widget or library files;
- the **registry** is metadata used for discovery and dependency resolution;
- the **package manager** validates, installs, and activates releases in the selected frontend store.

The official source lives in [`easybar-app/widgets`](https://github.com/easybar-app/widgets). The
official registry lives in [`easybar-app/registry`](https://github.com/easybar-app/registry). This site
builds the [Catalog](catalog.md) from current package metadata and README files.

The registry is optional. Either CLI can also install a package from another registry, a local
directory, or a direct archive.

## Package kinds

A **widget package** declares one entrypoint and becomes an active Lua widget in the selected
frontend when installed.

A **library package** exports Lua modules. Libraries do not create status items by themselves;
widgets load their declared exports with normal `require(...)` calls.

Dependencies are packages too. Missing or incompatible dependencies are resolved before activation.

## Compatibility

Manifest version 2 declares `minimum_easybar_kit_version`, not an EasyBar or EasyBar Native version.
That makes the package contract portable across frontends. A package that depends on an
EasyBar-only capability should document that requirement explicitly.

## Where to go next

| Goal                                   | Page                                                     |
| -------------------------------------- | -------------------------------------------------------- |
| Browse official packages               | [Catalog](catalog.md)                                    |
| Install, update, or remove packages    | [Install And Manage](manage.md)                          |
| Create or contribute a package         | [Create & Contribute](create-and-contribute.md)          |
| Write a manual Lua widget              | [Lua Widgets](../lua/overview.md)                        |
| Understand activation and transactions | [Package Store Internals](../internals/package-store.md) |

Installed widget code is trusted local code. Package validation protects structure and release
integrity; it is not a sandbox.
