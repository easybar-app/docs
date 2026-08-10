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

MkDocs serves the hand-written `content/` tree directly, so edits to normal documentation pages are
picked up by the development server without copying them through another build directory.

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
- EasyBar provides `config.schema.json` and `scripts/generate/lua_docs.py` for generated references.
- `widgets` provides package metadata and README content used to generate the Widget Store catalog.
- Generated reference and catalog pages are written into ignored paths below `content/` before
  MkDocs builds or serves the site.

The generated paths are:

```text
content/configuration/reference.md
content/lua/reference/
content/widget-store/catalog.md
content/widget-store/packages/
```

They are build artifacts, not hand-written source. `make clean` removes them together with fetched
source checkouts and the built site.

The documentation build requires the current EasyBar reference inputs. It does not fall back to
reference pages copied from another EasyBar documentation layout.

The site is rebuilt automatically when relevant EasyBar or widget content changes.

## License

Licensed under the [Apache License 2.0](LICENSE).
