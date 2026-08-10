# Install And Manage Packages

EasyBar can install packages from the official registry, another registry, a local directory, or a
direct archive. Package operations do not require the EasyBar app to be running, but reload EasyBar
after an install, update, or uninstall when you want the active Lua runtime to pick up the change.

For the concepts behind packages, libraries, and registries, start with [Widget Store](overview.md).

## Search the store

List every package in the official registry or filter by name, description, kind, or category:

```bash
easybar widgets search
easybar widgets search QUERY
```

Use another remote or local registry index with:

```bash
easybar widgets search QUERY --registry https://example.com/easybar/index.json
```

The generated [Catalog](catalog.md) is the website view of the official package source. The CLI
searches the selected live registry.

## Install an official package

Install the latest compatible immutable release by package name:

```bash
easybar widgets install PACKAGE_NAME
easybar config reload
```

Registry releases include a versioned archive URL and SHA-256. EasyBar verifies the digest before
extracting the archive and resolves required package dependencies before activation.

Installing an already installed package is an error. Use `widgets update` for a normal registry
upgrade. Use `--force` only when you intentionally want to replace the installed package from a
supported source, including reinstalling the same version:

```bash
easybar widgets install PACKAGE_NAME --force
```

Use another registry when needed:

```bash
easybar widgets install my-widget --registry https://example.com/easybar/index.json
```

The registry value may also be a local `index.json` path.

## List installed packages

```bash
easybar widgets installed
```

Filter by package kind or request machine-readable output:

```bash
easybar widgets installed --widgets-only
easybar widgets installed --libraries-only
easybar widgets installed --json
```

The command is offline and reports the package database under EasyBar's managed data directory.

## Check for updates

List newer registry releases without changing anything:

```bash
easybar widgets outdated
```

Update one package or every outdated package:

```bash
easybar widgets update PACKAGE_NAME
easybar widgets update --all
easybar config reload
```

A named update changes nothing when the selected registry does not contain a newer compatible
release. `update --all` processes outdated packages one at a time; a package that commits
successfully remains updated if a later package fails.

Pass `--registry` to use another remote or local registry. Updates only apply to packages whose
recorded installation source matches a release in that registry. Local packages and unrelated
archives are not silently replaced by `update --all`.

## Install a local package

A local package directory needs a valid `package.toml`; it does not need a Git repository or a
registry entry:

```bash
easybar widgets install ./my-widget --no-registry
```

With `--no-registry`, every dependency must already be installed. Without that option, EasyBar uses
installed compatible dependencies first and asks the selected registry for missing or incompatible
ones.

For package layout and manifest fields, see [Create & Contribute](create-and-contribute.md).

## Install an archive directly

Install a local archive by path:

```bash
easybar widgets install ./my-widget-0.1.0.tar.gz
```

A remote archive requires an explicit SHA-256:

```bash
easybar widgets install \
  https://example.com/my-widget-0.1.0.tar.gz \
  --sha256 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
```

The archive must place `package.toml` at its root. EasyBar rejects symbolic links, absolute archive
paths, and parent-directory traversal.

## Dependencies

Package dependencies use package names with exact or caret semantic-version constraints:

```toml
[dependencies]
shared = "^0.1.0"
```

A package is activated only when its dependency requirements can be satisfied. Library modules are
then available through their manifest-declared export names:

```lua
local retry = require("retry")
```

Dependencies that become unused are left installed. Removal is always explicit.

## Uninstall a package

```bash
easybar widgets uninstall PACKAGE_NAME
easybar config reload
```

EasyBar refuses to remove a package while another installed package depends on it. Uninstall removes
the package's managed versions and activation links; it never removes files from your configured
manual `widgets_dir`.

## Managed data

Package state lives below:

```text
~/.local/share/easybar/packages/
```

That directory is owned by the package manager. Do not edit active links or stored package versions
by hand during normal use. For the exact store layout, atomic replacement behavior, rollback, and
version retention rules, see [Package Store Internals](../internals/package-store.md).
