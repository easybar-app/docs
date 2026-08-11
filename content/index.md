<div class="easybar-hero" markdown>

<p class="easybar-hero__eyebrow">One Lua widget platform. Two macOS frontends.</p>

# Build the menu bar that fits your workflow

EasyBar is a small family of macOS tools built around one shared EasyBarKit runtime. Use **EasyBar**
for a customizable full-width bar, or **EasyBar Native** to host Lua widgets as independent macOS
status items. Both use the same Lua widget and package contracts, while keeping their user data and
command-line tools separate.

[Choose a product](products/index.md){ .md-button .md-button--primary }
[Browse widget packages](widget-store/catalog.md){ .md-button }
[Lua widget guides](lua/overview.md){ .md-button }

[![EasyBar running across the macOS menu bar](assets/bar.png)](assets/bar.png)

</div>

## Choose your frontend

<div class="easybar-feature-grid" markdown>

<article class="easybar-feature-card" markdown>

### :material-view-dashboard-outline:{ .lg .middle } EasyBar

The full-width customizable frontend. It provides native built-ins, groups, themes, calendar and
network integrations, the `easybar` CLI, and Lua widgets in one managed bar.

[Explore EasyBar](products/easybar/index.md)

</article>

<article class="easybar-feature-card" markdown>

### :material-apple:{ .lg .middle } EasyBar Native

The lightweight native status-area frontend. Lua widget roots become independent `NSStatusItem`s.
It has its own config, runtime, package store, logs, and `easybar-native` CLI, and it does not depend
on EasyBar's calendar or network agents.

[Explore EasyBar Native](products/easybar-native/index.md)

</article>

<article class="easybar-feature-card" markdown>

### :material-code-braces:{ .lg .middle } Shared Lua widgets

Write one Lua widget against the EasyBarKit API and use it with either frontend when the widget does
not depend on a frontend-specific capability.

[Create your first widget](lua/guides/first-widget.md)

</article>

<article class="easybar-feature-card" markdown>

### :material-package-variant-closed:{ .lg .middle } Independent packages

Official widgets and libraries are versioned independently. Each frontend installs packages into its
own managed store, so experimenting in EasyBar Native does not change EasyBar's active packages.

[Browse the Widget Store](widget-store/overview.md)

</article>

</div>

## The project family

| Tool           | Purpose                                                                          | User-facing command                                   |
| -------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| EasyBar        | Custom full-width bar with native built-ins and Lua widgets                      | `easybar`                                             |
| EasyBar Native | Native `NSStatusItem` host for Lua widgets and Inbox                             | `easybar-native`                                      |
| EasyBarKit     | Shared Swift/Lua runtime, rendering, package manager, IPC, and reusable services | library/runtime products                              |
| Calendar agent | EasyBar's EventKit helper service                                                | managed by `easybar agent ...`                        |
| Network agent  | EasyBar's Wi-Fi/network helper service                                           | managed by `easybar agent ...`                        |
| Widget Store   | Independently versioned Lua widgets and libraries                                | `easybar widgets ...` or `easybar-native widgets ...` |

The two frontends share implementation, not installation state. See [Platform](platform/index.md) for
the repository and ownership model.

## Where to go next

- Start the complete custom bar with [EasyBar Quick Start](products/easybar/quick-start.md).
- Install the isolated status-item frontend from [EasyBar Native](products/easybar-native/index.md).
- Compare the two command-line tools in [Command Line](cli/index.md).
- Learn the shared extension model in [Lua Widgets](lua/overview.md).
- Understand the implementation boundary in [EasyBarKit](platform/easybar-kit.md) and [Internals](internals/overview.md).
