# EasyBar Documentation

Source for [easybar.dev](https://easybar.dev/), the documentation site for the EasyBar project family.

The site documents multiple independently installable tools rather than treating the ecosystem as one application:

- **EasyBar** — the customizable full-width macOS bar, its `easybar` CLI, built-ins, and helper agents;
- **EasyBar Native** — the isolated `NSStatusItem` frontend and its `easybar-native` CLI;
- **EasyBarKit** — the shared Swift/Lua implementation used by both frontends;
- **widgets** and **registry** — independently versioned Lua packages and package metadata;
- the shared Lua authoring and package contracts.

## Build locally

```bash
make build
```

The generated site is written to `.site/`. Serve it with live reload using:

```bash
make serve
```

Override the source revisions used for generated references:

```bash
make build EASYBAR_KIT_REF=v1.0.0 WIDGETS_REF=main
```

Use sibling checkouts while developing uncommitted EasyBarKit or widget changes:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_KIT_ROOT=../easybar-kit \
  WIDGETS_ROOT=../widgets
```

## Content ownership

Hand-written documentation is grouped by ownership:

```text
content/
├── products/       # EasyBar and EasyBar Native user documentation
├── cli/            # easybar and easybar-native command-line documentation
├── lua/            # frontend-portable Lua authoring guides
├── widget-store/   # shared package discovery and management
├── platform/       # EasyBarKit, helper products, repository map
└── internals/      # contributor architecture and implementation details
```

Generated documentation remains source-owned by EasyBarKit or `widgets`:

```text
content/products/easybar/configuration/reference.md
content/lua/reference/
content/widget-store/catalog.md
content/widget-store/packages/
```

EasyBarKit provides `config.schema.json` and `scripts/generate/lua_docs.py`. The `widgets` repository provides package metadata and README content. Generated pages are written directly into ignored paths below `content/` before MkDocs runs; they are not hand-edited.

`make clean` removes generated pages, fetched source checkouts, and `.site/` without touching hand-written content.

## Verification

Run the complete documentation verification suite with:

```bash
make check
```

This generates the current references, builds MkDocs in strict mode, and checks formatting.

## License

Licensed under the [Apache License 2.0](LICENSE).
