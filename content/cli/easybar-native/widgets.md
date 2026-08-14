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

Package changes are written below `~/.local/share/easybar-native/packages`. Reload EasyBar Native
after installing, updating, or removing a package:

```bash
easybar-native config reload
```

`widgets pin` and `widgets unpin` change update policy only and do not require a runtime reload.

Run `easybar-native widgets COMMAND --help` for command-specific options. See
[Install and manage packages](../../widget-store/manage.md) for local packages, custom registries,
checksums, dependencies, and update behavior.
