# Inbox

The `easybar-native inbox` commands publish and manage messages in EasyBar Native's built-in Inbox.

## Publish a message

```bash
easybar-native inbox send \
  --source backup \
  --id nightly \
  --severity error \
  --title "Backup failed" \
  --message "The nightly backup did not complete."
```

`--source` and `--title` are required. A stable `--id` lets a later command update the same message.

## Inspect and update messages

```bash
easybar-native inbox list
easybar-native inbox list --unread --json
easybar-native inbox mark-read --source backup --id nightly
easybar-native inbox mark-unread --source backup --id nightly
easybar-native inbox dismiss --source backup --id nightly
easybar-native inbox remove --source backup --id nightly
easybar-native inbox clear --source backup
easybar-native inbox clear --all
```

Run `easybar-native inbox COMMAND --help` for all fields and filters. See
[Native Inbox](../../lua/guides/inbox.md) for message persistence, actions, grouping, and the Lua API.
