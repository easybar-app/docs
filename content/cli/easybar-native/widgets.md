# Widget packages

The `easybar-native widgets` commands manage packages installed for EasyBar Native.

```bash
easybar-native widgets search QUERY
easybar-native widgets install PACKAGE[@VERSION]
easybar-native widgets installed
easybar-native widgets pin PACKAGE
easybar-native widgets unpin PACKAGE
easybar-native widgets outdated
easybar-native widgets update PACKAGE
easybar-native widgets update --all
easybar-native widgets uninstall PACKAGE
```

Registry-backed `search`, `install`, `outdated`, and `update` commands accept `--refresh` when you
need an unconditional fetch of the selected remote registry:

```bash
easybar-native widgets search QUERY --refresh
easybar-native widgets install PACKAGE[@VERSION] --refresh
easybar-native widgets outdated --refresh
easybar-native widgets update --all --refresh
```

Normal remote-registry requests revalidate the locally cached index with HTTP validators. `--refresh`
omits those cached validators for that request, validates the returned index, and replaces the normal
registry cache with the fresh response. Use it when a newly published package or release is not yet
visible through a normal registry request. Local registry files are always read directly.

Package changes are written below `~/.local/share/easybar-native/packages`. Reload EasyBar Native
after installing, updating, or removing a package:

```bash
easybar-native config reload
```

`widgets pin` and `widgets unpin` change update policy only and do not require a runtime reload.

Run `easybar-native widgets COMMAND --help` for command-specific options. See
[Install and manage packages](../../widget-store/manage.md) for local packages, custom registries,
checksums, dependencies, and update behavior.
