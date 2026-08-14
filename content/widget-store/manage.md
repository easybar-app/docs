# Install And Manage Packages

Both EasyBar frontends can install packages from the official registry, another registry, a local
directory, or a direct archive. Package operations do not require the selected frontend to be
running; reload that frontend when you want its Lua runtime to pick up a change.

The examples below use `easybar`, which operates on EasyBar's store. Replace it with
`easybar-native` to perform the same package operation against EasyBar Native's isolated store.

```text
easybar        -> ~/.local/share/easybar/packages
easybar-native -> ~/.local/share/easybar-native/packages
```

For the concepts behind packages, libraries, and registries, start with [Widget Store](index.md).

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

Remote registry operations revalidate the registry index before using it. EasyBarKit keeps a local
validated copy and uses standard HTTP validators such as `ETag` and `Last-Modified`, so an unchanged
registry can be reused without downloading the complete index again. When the registry changes,
commands such as `search`, `install`, `outdated`, and `update` use the new index immediately. Local
registry files are read directly.

## Install an official package

Install the latest compatible immutable release by package name:

```bash
easybar widgets install PACKAGE_NAME
easybar config reload
```

Install an exact published registry version by appending `@VERSION`:

```bash
easybar widgets install PACKAGE_NAME@VERSION
```

The version selector applies only to registry package names. It does not pin the package: a later
`widgets update` can still move it to a newer published release. To roll an installed package back
to an older registry version, combine the selector with `--force`:

```bash
easybar widgets install PACKAGE_NAME@OLDER_VERSION --force
```

Registry releases include a versioned archive URL and SHA-256. The shared package manager verifies
the digest before extracting the archive and resolves required dependencies before activation.

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

The command is offline and reports the package database owned by the selected frontend.

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

With `--no-registry`, every dependency must already be installed. Without that option, the package
manager uses installed compatible dependencies first and asks the selected registry for missing or
incompatible ones.

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

The archive must place `package.toml` at its root. The package manager rejects symbolic links, absolute archive paths, and parent-directory traversal.

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

The package manager refuses to remove a package while another installed package depends on it.
Uninstall removes the package's managed versions and activation links; it never removes files from
your configured manual `widgets_dir`.

## Managed data

Package state is frontend-owned:

```text
EasyBar        ~/.local/share/easybar/packages/
EasyBar Native ~/.local/share/easybar-native/packages/
```

Do not edit active links or stored versions by hand. For the exact layout, atomic replacement,
rollback, and retention rules, see [Package Store Internals](../internals/package-store.md).
