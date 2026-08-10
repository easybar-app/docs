# Development

The application is developed as sibling repositories rather than one monolithic Swift package.

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

Both frontend Swift packages resolve `../easybar-kit` by default. The widgets tests also use a
sibling kit checkout unless `EASYBAR_KIT_ROOT` is set.

## Tools

For the complete EasyBarKit and widgets checks on macOS, install the tools used by their Makefiles:

```bash
brew install lua stylua
```

Node-based Prettier and Taplo commands are pinned by the Makefiles and can run through `npx`.
Swift dependencies are resolved by SwiftPM.

## Common verification

Run the complete repository check in every checkout you change:

```bash
make check
```

The Makefiles share the same high-level vocabulary where it applies:

- `make build` builds Swift products;
- `make test` runs repository tests;
- `make check` combines tests and lint/verification;
- `make fmt` formats supported files;
- `make lint` checks formatting;
- `make clean` removes generated local build output.

EasyBarKit additionally owns generated-source checks and Lua runtime tests. Widgets owns package
validation and Lua package tests. Registry and docs use Python-based validation/build tests instead
of Swift tests.

## Run a frontend from source

With `easybar-kit` beside the frontend checkout:

```bash
cd easybar
make run
```

or:

```bash
cd easybar-native
make run
```

Each frontend `run` target first builds EasyBarKit's `EasyBarLuaRuntime` helper and exposes it in the
frontend build tree so source runs use the same runtime discovery path.

## Install local Swift products

EasyBarKit installs its CLI/runtime/agent executables into `~/.local/bin` by default:

```bash
cd easybar-kit
make install-local
```

Each frontend also provides `make install-local`. It first installs the shared kit executables and
then installs that frontend's release executable into the same `LOCAL_BIN_DIR`:

```bash
cd easybar
make install-local

cd ../easybar-native
make install-local
```

Override the executable destination with `LOCAL_BIN_DIR=/path/to/bin`.

The widgets, registry, and documentation repositories intentionally have no `install-local` target:
they do not produce a local executable product that should be installed into a bin directory.

## Generated EasyBarKit artifacts

EasyBarKit keeps generated theme tokens, event tokens, Lua API stubs, and config outputs checked in.
After changing their canonical inputs, run:

```bash
cd easybar-kit
make generate
make check-generated
```

The documentation repository generates its reference pages from EasyBarKit and widgets during its
own build; those pages are build artifacts rather than hand-written sources.

## Widget development

With `easybar-kit` and `widgets` side by side:

```bash
cd widgets
make check
make package PACKAGE=my-widget OUTPUT_DIR=dist
```

Packages use manifest version 2 and target `minimum_easybar_kit_version`. There is no manifest-v1
fallback in the current package contract.

## Documentation development

The docs repository can fetch source revisions itself:

```bash
cd docs
make build
make serve
```

For uncommitted sibling checkouts, avoid fetching and point the build at the local trees:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_KIT_ROOT=../easybar-kit \
  WIDGETS_ROOT=../widgets
```

## Repository ownership

- `easybar-kit` owns reusable runtime, widgets, config, Lua, package management, CLI, and helper
  agents;
- `easybar` owns only the custom full-width bar frontend;
- `easybar-native` owns only the native status-item frontend;
- `widgets` owns independently versioned Lua packages;
- `registry` owns published package metadata/checksums;
- `docs` owns easybar.dev hand-written content and generated-site assembly.

Continue with [Architecture](architecture/overview.md), [Agents](agents/overview.md), or the
[Lua runtime](lua-runtime/overview.md) for subsystem details.
