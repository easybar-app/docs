# EasyBar Documentation

Source for [easybar.dev](https://easybar.dev/).

This repository owns the hand-written documentation, MkDocs configuration, and final site build.
During each build it fetches the EasyBar and widgets repositories, then generates the configuration,
Lua API, and widget package reference pages from their current source.

## Build locally

```bash
make build
```

The generated site is written to `.site/`. To serve it with live reload:

```bash
make serve
```

Override either source revision when validating a release or historical build:

```bash
make build EASYBAR_REF=v0.43.0 WIDGETS_REF=main
```

For local development across sibling checkouts without fetching from GitHub:

```bash
make build \
  SKIP_FETCH=1 \
  EASYBAR_ROOT=../easybar \
  WIDGETS_ROOT=../widgets
```

## Content ownership

- `content/` contains hand-written documentation and site assets.
- EasyBar generates the configuration and Lua API references from its source.
- `widgets` supplies package metadata and package README content.
- `.build/content/` is the disposable assembled documentation tree used by MkDocs.

Changes to EasyBar's documented API or widget packages trigger a Cloudflare Pages deploy hook, so
the site rebuilds without copying generated pages into another repository.

## License

Licensed under the [Apache License 2.0](LICENSE).
