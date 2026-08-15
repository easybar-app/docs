# Widget packages

The `easybar widgets` commands manage packages installed for EasyBar.

```bash
easybar widgets search QUERY
easybar widgets install PACKAGE[@VERSION]
easybar widgets installed
easybar widgets pin PACKAGE
easybar widgets unpin PACKAGE
easybar widgets outdated
easybar widgets update PACKAGE
easybar widgets update --all
easybar widgets uninstall PACKAGE
```

Registry-backed `search`, `install`, `outdated`, and `update` commands accept `--refresh` when you
need an unconditional fetch of the selected remote registry:

```bash
easybar widgets search QUERY --refresh
easybar widgets install PACKAGE[@VERSION] --refresh
easybar widgets outdated --refresh
easybar widgets update --all --refresh
```

Normal remote-registry requests revalidate the locally cached index with HTTP validators. `--refresh`
omits those cached validators for that request, validates the returned index, and replaces the normal
registry cache with the fresh response. Use it when a newly published package or release is not yet
visible through a normal registry request. Local registry files are always read directly.

Package changes are written below `~/.local/share/easybar/packages`. Reload EasyBar after installing,
updating, or removing a package:

```bash
easybar config reload
```

`widgets pin` and `widgets unpin` change update policy only and do not require a runtime reload.

Run `easybar widgets COMMAND --help` for command-specific options. See
[Install and manage packages](../../widget-store/manage.md) for local packages, custom registries,
checksums, dependencies, and update behavior.
