# Reusable Modules

EasyBar has two sources of widget code. Manual `.lua` files below `widgets_dir` are discovered recursively except reusable modules below `shared/`. Installed packages expose only their manifest-declared widget entrypoints and exports; package directories are not recursive module roots.

Manual module paths and the managed `active/shared` export namespace are added to Lua's standard module search path, so widget code can use normal `require(...)` calls without changing `package.path`.

## Recommended layout

```text
~/.config/easybar/widgets/
├── simple/
│   └── clock.lua
├── github/
│   ├── widget.lua
│   └── README.md
├── brew/
│   ├── widget.lua
│   └── README.md
├── shared/
│   ├── inbox.lua
│   ├── retry.lua
│   ├── text.lua
│   ├── brew/
│   │   └── policy.lua
│   └── status/
│       └── init.lua
└── assets/
    └── github.svg
```

Lua files below `shared/` load only through `require(...)`. Every `.lua` file elsewhere below
`widgets_dir` is eligible for direct widget discovery, so put reusable support code under `shared/`
when it must not execute as a widget entrypoint.

Keep module top levels declarative: create local functions or tables and return the public value. Do
not start timers, commands, subscriptions, or inbox publishing until an explicit function is called
by the consuming widget.

Keep small examples in the matching category. Use a service directory when an integration gains
configuration, documentation, tests, or assets. Use a service namespace below `shared/` when that
integration needs reusable Lua modules.

Do not install multiple presentation variants for the same service unless duplicate polling is intentional.

## Create a module

A module normally returns one table containing its public functions:

```lua
-- ~/.config/easybar/widgets/shared/text.lua
local M = {}

function M.trim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

return M
```

Use it from any Lua file:

```lua
local text = require("text")

local value = text.trim("  ready  ")
```

EasyBar resolves that call from:

```text
<widgets_dir>/shared/text.lua
```

## Package directories

For a larger module, use an `init.lua` file:

```text
shared/
└── status/
    └── init.lua
```

Then load it with:

```lua
local status = require("status")
```

Dots in module names map to subdirectories. For example:

```lua
local format = require("network.format")
```

resolves to:

```text
<widgets_dir>/shared/network/format.lua
```

## Shared text helper

The official [`shared` package](https://github.com/easybar-app/widgets/tree/main/packages/shared) includes a small text module:

```lua
local text = require("text")

local clean = text.trim(command_output)
local short = text.truncate(clean, 80)
```

`text.lua` provides:

- `text.trim(value)`
- `text.truncate(value, maximum_length, omission?)`

This module is installed and updated with the `shared` package. It is not a built-in part of the public `easybar` API.

## Inbox data helper

The official inbox packages share the `shared` package's `inbox.lua` for three data-boundary operations:

```lua
local inbox = require("inbox")

local values = inbox.decode_array(easybar.json, command_output)
if values == nil then
    local message = inbox.error_message(command_output, "The service returned invalid data")
    -- Keep the last valid snapshot and publish `message` as an additional error item.
end

local timestamp = inbox.timestamp("2026-08-03T09:45:00.123+02:00")
```

`inbox.lua` provides:

- `inbox.decode_array(json_module, output)` decodes a dense JSON array and returns `nil` for invalid
  JSON or an object-shaped response. Pass `easybar.json` explicitly because modules do not receive
  the widget-scoped API automatically.
- `inbox.error_message(output, fallback)` trims and limits an error body to
  `inbox.maximum_error_length` characters, using the fallback when output is empty. The official
  value is 12,000 characters, safely below the native inbox body's byte limit even for UTF-8 text.
- `inbox.timestamp(value)` converts an ISO-8601 timestamp with `Z` or a numeric timezone offset to
  Unix seconds. Fractional seconds are accepted and discarded. Invalid dates and timestamps
  without a timezone return `nil`.

These helpers deliberately do not own snapshots, refresh scheduling, or actions. The publishing
widget remains responsible for validating service-specific fields and deciding whether a failed
refresh should retain existing items.

The `shared` package's `retry.lua` module coordinates asynchronous attempts through `easybar.after(...)`. Pass
the widget-scoped API explicitly because modules do not receive `easybar` automatically:

```lua
local retry = require("retry")

retry.run(easybar, {
    delays = { 2, 5 },
    attempt = function(done, attempt_number)
        return easybar.spawn_async({ "gh", "api", "notifications" }, {}, done)
    end,
    should_retry = retry.is_transient_network_error,
    on_complete = function(output, code, attempts)
        -- Runs once with the final result.
    end,
})
```

The first attempt starts immediately. `delays[1]` is the wait before attempt 2, `delays[2]` is the
wait before attempt 3, and so on. When no delay remains, the last result is final.

`retry.run(...)` returns a `RetryOperation` with:

- `operation:is_active()`
- `operation:cancel()`

Store that handle only when the widget has an actual cancellation or replacement policy. The retry
callbacks and host timers keep the operation alive until completion, so assigning an unused
`active_refresh` variable adds dead state without changing behavior.

When you do store the handle, clear it in `on_complete` and before cancellation:

```lua
local active_refresh

local function cancel_refresh()
    local operation = active_refresh
    active_refresh = nil

    if operation ~= nil then
        operation:cancel()
    end
end
```

Cancellation stops either the active asynchronous command or the pending backoff timer and does not
call `on_complete`.

`retry.is_transient_network_error(output, code)` is a conservative heuristic for DNS, connection,
timeout, TLS, and common gateway failures. It never retries status `0` and never treats cancellation
status `130` as retryable. The retry helper is intended for idempotent reads. Do not automatically
retry updates, upgrades, acknowledgements, or other mutations because the remote operation may have
succeeded even when the local response was lost.

The module includes LuaLS annotations for `RetryOptions`, `RetryOperation`, attempt callbacks, retry
predicates, and completion callbacks. Keeping these annotations beside the implementation means
editors can validate custom retry policies without adding retry types to the global `easybar` stub.

## Module lifetime and state

Lua caches successful `require(...)` calls in `package.loaded`. Requiring the same module again in
the same runtime returns the same value without executing the module a second time.

That means mutable module state is shared by every widget that requires the module. Prefer stateless
helper modules unless shared state is intentional.

Restarting the Lua runtime or reloading EasyBar clears the process and therefore clears the module
cache.

## EasyBar API access

Every discovered file receives a widget-scoped `easybar` value during direct startup execution. A
module loaded later through `require(...)` does not receive that injected value automatically.

Keep reusable modules independent from `easybar` at top level. When a helper needs host-specific data, pass the value explicitly:

```lua
-- shared/widget_style.lua
local M = {}

function M.label(color, value)
    return {
        string = value,
        color = color,
    }
end

return M
```

```lua
-- clock.lua
local widget_style = require("widget_style")

local label = widget_style.label(easybar.theme.ref.text, os.date("%H:%M"))
```

Resolve files beside the current entrypoint with `easybar.asset(...)`. Use `easybar.asset("@/assets/name.svg")` for assets shared from the configured widgets root, then pass the resolved path to a helper only when needed.

## Naming and precedence

For manually managed widgets, EasyBar searches modules in this order:

```text
<widgets_dir>/?.lua
<widgets_dir>/?/init.lua
<widgets_dir>/shared/?.lua
<widgets_dir>/shared/?/init.lua
```

Dots map to subdirectories. A generic `require("text")` normally resolves to
`<widgets_dir>/shared/text.lua` when no top-level `text.lua` or `text/init.lua` exists. Because Lua
files outside `shared/` are also discovered as widgets, prefer `shared/<namespace>/...` for reusable
manual modules.

Installed packages contribute only their manifest-declared exports to Lua module lookup. Package
directories themselves are not added to `package.path`. Manual module paths are configured afterward
and therefore take precedence, while managed exports remain available as a fallback.

Successful `require(...)` calls are cached process-wide, so use distinct export names when two
packages must not share an implementation. Namespaced exports such as `my_widget.policy` are a good
fit for package-specific helpers. Package creation and export rules live in
[Create And Publish](../../widget-store/creating-packages.md).

## Errors

Every selected widget source is executed independently: a managed package contributes its declared entrypoint, while manual discovery selects eligible `.lua` files below `widgets_dir`. A syntax error or top-level failure is reported for that source, its transactional changes are rolled back, and the remaining widget sources continue loading.

A missing or failing `require(...)` call fails the consuming file in the same way. Files below
`shared/` are not executed directly, so a broken support module is reported when a widget requires
it.
