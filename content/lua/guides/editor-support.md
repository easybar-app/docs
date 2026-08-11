# Editor Support

Each frontend installs the same generated EasyBarKit LuaLS stub into its own data directory:

| Frontend       | Stub                                            | Managed modules                                        |
| -------------- | ----------------------------------------------- | ------------------------------------------------------ |
| EasyBar        | `~/.local/share/easybar/easybar_api.lua`        | `~/.local/share/easybar/packages/active/shared`        |
| EasyBar Native | `~/.local/share/easybar-native/easybar_api.lua` | `~/.local/share/easybar-native/packages/active/shared` |

Use the paths for the frontend whose widgets you are editing.

## EasyBar workspace

For `~/.config/easybar/widgets/.luarc.json`:

```json
{
  "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
  "runtime": {
    "version": "Lua 5.5",
    "path": ["?.lua", "?/init.lua", "shared/?.lua", "shared/?/init.lua"]
  },
  "workspace": {
    "library": [
      "~/.local/share/easybar/easybar_api.lua",
      "~/.local/share/easybar/packages/active/shared"
    ]
  },
  "diagnostics": {
    "globals": ["easybar"]
  }
}
```

## EasyBar Native workspace

For `~/.config/easybar-native/widgets/.luarc.json`, use the Native paths instead:

```json
{
  "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
  "runtime": {
    "version": "Lua 5.5",
    "path": ["?.lua", "?/init.lua", "shared/?.lua", "shared/?/init.lua"]
  },
  "workspace": {
    "library": [
      "~/.local/share/easybar-native/easybar_api.lua",
      "~/.local/share/easybar-native/packages/active/shared"
    ]
  },
  "diagnostics": {
    "globals": ["easybar"]
  }
}
```

The `runtime.path` entries resolve modules from the open manual-widget workspace. Adding the selected
frontend's managed `active/shared` directory exposes installed exports such as `retry` without
turning package entrypoints into manual widgets.

If your editor sees the `easybar` global but not newly added nested types or properties, start or
restart the selected frontend so it reinstalls the latest generated stub.

Keep reusable-module annotations beside the module implementation. Package-specific LuaLS types can
then be discovered through normal module resolution without polluting the global EasyBar API.
