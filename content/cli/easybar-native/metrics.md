# Metrics

Inspect EasyBar Native and its Lua runtime from the terminal.

## Snapshot

```bash
easybar-native metrics
```

The snapshot reports process resource use, Lua transport activity, widget-tree updates, events, and
active subscriptions.

## Watch mode

```bash
easybar-native metrics --watch
```

Watch mode samples continuously and displays rates and compact graphs. One-shot rate fields are
`0.0/s` because the sampler starts only while a metrics client is connected.

Use `easybar-native metrics --help` for output and socket options.
