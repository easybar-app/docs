# EasyBar Documentation

Source for [easybar.dev](https://easybar.dev/).

## Build locally

Build the documentation with:

```bash
make build
```

The generated site is written to `.site/`.

Serve it locally with live reload:

```bash
make serve
```

Override source revisions when building against specific releases:

```bash
make build EASYBAR_REF=v0.43.0 WIDGETS_REF=main
```

Use sibling checkouts for local development:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_ROOT=../easybar \
  WIDGETS_ROOT=../widgets
```

## Content

- `content/` contains hand-written documentation and site assets.
- EasyBar provides configuration and Lua API reference data.
- `widgets` provides package metadata and documentation.
- `.build/content/` contains the generated documentation tree used by MkDocs.

The site is rebuilt automatically when relevant EasyBar or widget content changes.

## License

Licensed under the [Apache License 2.0](LICENSE).
