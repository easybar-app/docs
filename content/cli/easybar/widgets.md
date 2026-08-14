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

Package changes are written below `~/.local/share/easybar/packages`. Reload EasyBar after installing,
updating, or removing a package:

```bash
easybar config reload
```

`widgets pin` and `widgets unpin` change update policy only and do not require a runtime reload.

Run `easybar widgets COMMAND --help` for command-specific options. See
[Install and manage packages](../../widget-store/manage.md) for local packages, custom registries,
checksums, dependencies, and update behavior.
