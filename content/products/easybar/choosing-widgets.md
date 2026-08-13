# Choose Built-ins, Widget Store, Or Lua

EasyBar gives you three practical ways to add functionality:

- native built-ins configured in `config.toml`;
- installable packages from the [Widget Store](../../widget-store/index.md);
- custom Lua widgets you write yourself.

Start with the least custom option that solves the problem. That usually means a built-in first, a
store package second, and new Lua code only when the behavior is specific to your workflow.

## Use built-ins when

Built-ins are the best default for common macOS and system-integrated data:

- spaces and AeroSpace state;
- battery;
- Wi-Fi and network fields;
- calendar and appointments;
- time and date;
- volume;
- front app state;
- CPU status.

Built-ins keep platform-sensitive behavior in Swift, use the native rendering model, and usually need
less maintenance than scripts.

```toml
[builtins.battery]
enabled = true

[builtins.wifi]
enabled = true

[builtins.calendar]
enabled = true
```

Use [Built-ins](configuration/builtins/index.md) for supported widgets and
[Native Groups](configuration/builtins/native-groups.md) for shared visual containers.

## Use the Widget Store when

Use the store when the integration already exists as a maintained package but is not a native
built-in. Store packages are useful for service integrations, command-backed status, native-inbox
publishers, and reusable Lua libraries.

```bash
easybar widgets search
easybar widgets install PACKAGE_NAME
easybar config reload
```

Browse the [Widget Store Catalog](../../widget-store/catalog.md) or read
[Install And Manage](../../widget-store/manage.md).

A store widget still runs as trusted Lua code. The difference is ownership: the package is versioned
and updated through EasyBar's package manager instead of being maintained in your manual widget
directory.

## Write Lua when

Write a manual Lua widget when the behavior is genuinely specific to your machine or workflow:

- custom text, icons, or composed layouts;
- local scripts or project status;
- custom mouse, hover, scroll, or slider interactions;
- bespoke popup content;
- integrations that do not belong in a reusable package yet.

Start with [First Widget](../../lua/guides/first-widget.md).

## Decision rule

Use this order:

1. **Does EasyBar already provide a built-in?** Configure it.
2. **Does the Widget Store already provide the integration?** Install it.
3. **Is the behavior personal or new?** Write Lua.
4. **Did the Lua widget become reusable?** Package it with [Create & Contribute](../../widget-store/create-and-contribute.md).

A strong setup can use all three: native widgets for platform integrations, store packages for
reusable service integrations, and manual Lua for the last mile of personal behavior.

