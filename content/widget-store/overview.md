# Widget Store

The Widget Store is the place to discover and manage ready-made EasyBar integrations.

Use it when you want a widget or reusable Lua library without maintaining the implementation in
`~/.config/easybar/widgets` yourself. If you want to write custom behavior from scratch, use
[Lua Widgets](../lua/overview.md) instead.

## How the store fits together

EasyBar separates three concerns:

- **packages** contain versioned widget or library files;
- the **registry** is a metadata index used for discovery and dependency resolution;
- the **package manager** installs validated package releases and activates the selected versions.

The official package source lives in the
[`easybar-app/widgets`](https://github.com/easybar-app/widgets) repository. The official registry
lives in [`easybar-app/registry`](https://github.com/easybar-app/registry). The documentation site
builds the [Catalog](catalog.md) from the current package metadata and README files.

The registry is optional. EasyBar can also install a package from another registry, a local package
directory, or a direct archive.

## Package kinds

A **widget package** declares one entrypoint and becomes an active EasyBar widget when installed.

A **library package** exports one or more Lua modules. Libraries do not create bar items by
themselves; widgets load their exports with normal `require(...)` calls.

Dependencies are versioned packages too. Installing a widget from a registry resolves missing or
incompatible dependencies before the widget is activated.

## Common workflow

Find a package:

```bash
easybar widgets search
easybar widgets search github
```

Install it:

```bash
easybar widgets install PACKAGE_NAME
easybar config reload
```

Inspect installed packages and available updates:

```bash
easybar widgets installed
easybar widgets outdated
```

Update one package or all outdated packages:

```bash
easybar widgets update PACKAGE_NAME
easybar widgets update --all
easybar config reload
```

## Where to go next

| Goal                                              | Page                                                     |
| ------------------------------------------------- | -------------------------------------------------------- |
| Browse official packages                          | [Catalog](catalog.md)                                    |
| Install, update, or remove packages               | [Install And Manage](manage.md)                          |
| Create, publish, or contribute a package          | [Create & Contribute](creating-packages.md)              |
| Write a manual Lua widget                         | [Lua Widgets](../lua/overview.md)                        |
| Understand the on-disk store and activation model | [Package Store Internals](../internals/package-store.md) |

Installed widget code is trusted code. Package installation validates structure and release
integrity, but it is not a sandbox. Review third-party package source with the same care you would
apply to any local script you choose to run.
