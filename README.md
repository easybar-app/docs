# EasyBar Documentation

Source for [easybar.dev](https://easybar.dev/), the unified documentation site for EasyBar, EasyBar
Native, EasyBarKit, Lua widgets, and the Widget Store.

## Features

- Product installation, configuration, CLI, and troubleshooting guides
- Shared Lua widget guides and generated EasyBarKit API references
- Generated configuration reference from the EasyBarKit schema
- Generated Widget Store catalog from official package metadata and READMEs
- Contributor architecture and development documentation

## Requirements

- Python 3.11 or newer
- Node.js with `npx` for formatting checks

## Build locally

```bash
make build
```

The generated site is written to `.site/`. Serve it with live reload using:

```bash
make serve
```

Use sibling source checkouts while documenting uncommitted EasyBarKit or widget changes:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_KIT_ROOT=../easybar-kit \
  WIDGETS_ROOT=../widgets
```

Run the complete build and formatting checks with:

```bash
make check
```

## Documentation

- [Choose an EasyBar product](https://easybar.dev/products/)
- [Lua widgets](https://easybar.dev/lua/overview/)
- [Widget Store](https://easybar.dev/widget-store/overview/)
- [EasyBarKit platform](https://easybar.dev/platform/)
- [Development](https://easybar.dev/internals/development/)

## License

Licensed under the [Apache License 2.0](./LICENSE).
