# Development

The project is developed as sibling repositories rather than one monolithic checkout.

## Recommended checkout

```text
projects/
├── easybar-kit/
├── easybar/
├── easybar-native/
├── widgets/
├── registry/
└── docs/
```

Both frontend Swift packages depend on EasyBarKit. Widget tests also use a compatible Kit checkout.

## Common verification

Run the repository's complete check after changing it:

```bash
make check
```

The Makefiles share high-level targets where they apply: `build`, `test`, `check`, `fmt`, `lint`, and
`clean`. EasyBarKit owns generated runtime/API checks; widgets owns package validation; docs owns
MkDocs generation and link/build validation.

## Run a frontend from source

With `easybar-kit` beside the frontend:

```bash
cd easybar
make run
```

or:

```bash
cd easybar-native
make run
```

Each frontend builds or locates the EasyBarKit runtime products it needs without copying the shared
source into the frontend repository.

## Local installation boundaries

The frontends intentionally have different local-install behavior.

### EasyBar

`easybar` owns the complete custom-bar development installation, including its public `easybar` CLI
and the Calendar/Network helper-agent setup required by the full product.

```bash
cd easybar
make install-local
```

### EasyBar Native

Native installs only its app and public Native CLI link:

```bash
cd easybar-native
make install-local
```

Expected user-facing installation:

```text
~/Applications/EasyBarNative.app
~/.local/bin/easybar-native
```

It must not install, stop, replace, or uninstall EasyBar's helper agents, `easybar` CLI, config, or
package store.

### EasyBarKit

EasyBarKit can still build and test all reusable executable products directly. Treat it as the shared
implementation repository, not as a third menu-bar frontend with user-owned config.

## User-data isolation during development

Do not point the two frontends at the same mutable roots by accident:

```text
EasyBar
  ~/.config/easybar
  ~/.local/share/easybar
  ~/.local/state/easybar

EasyBar Native
  ~/.config/easybar-native
  ~/.local/share/easybar-native
  ~/.local/state/easybar-native
```

Explicit environment overrides are useful for tests, but production defaults should preserve this
separation.

## Generated EasyBarKit artifacts

EasyBarKit keeps generated theme tokens, event tokens, Lua API stubs, and config outputs checked in.
After changing canonical inputs:

```bash
cd easybar-kit
make generate
make check-generated
```

The docs repository generates the public config/Lua references from EasyBarKit during its own build;
those pages are site build artifacts rather than hand-written sources.

## Widget development

With `easybar-kit` and `widgets` side by side:

```bash
cd widgets
make check
make package PACKAGE=my-widget OUTPUT_DIR=dist
```

Packages use manifest version 2 and target `minimum_easybar_kit_version`. Package authors should not
fork a manifest for EasyBar Native; frontend-specific capability assumptions belong in package docs.

## Documentation development

```bash
cd docs
make build
make serve
```

For uncommitted sibling Kit/widget changes:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_KIT_ROOT=../easybar-kit \
  WIDGETS_ROOT=../widgets
```

## Ownership rule

- shared runtime, Lua, package, config, rendering, CLI core, and reusable helper products → `easybar-kit`;
- full-width bar presentation and EasyBar distribution → `easybar`;
- status-item presentation, Native CLI launcher, and Native distribution → `easybar-native`;
- independently versioned Lua packages → `widgets`;
- release metadata/checksums → `registry`;
- site content and generation wiring → `docs`.
