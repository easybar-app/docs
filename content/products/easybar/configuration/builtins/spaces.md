# Spaces

The native spaces widget renders AeroSpace workspaces and their visible application icons.

- `[builtins.spaces]` controls placement and the outer box model.
- `[builtins.spaces.layout]` controls the workspace-pill layout.
- `[builtins.spaces.text]` controls labels.
- `[builtins.spaces.icons]` controls application icons.

<div class="easybar-showcase" markdown>

<figure markdown>
[![EasyBar Spaces widget with workspace labels](../../../../assets/spaces.png){ .screenshot-compact .screenshot-spaces }](../../../../assets/spaces.png)
<figcaption>Workspace labels with the focused space highlighted</figcaption>
</figure>

<figure markdown>
[![EasyBar Spaces widget with front-app icons](../../../../assets/spaces_front_app.png){ .screenshot-compact .screenshot-spaces-front-app }](../../../../assets/spaces_front_app.png)
<figcaption>Workspace labels combined with visible application icons</figcaption>
</figure>

</div>

## Collapsed inactive spaces

The content settings interact as follows:

| `show_label` | `show_icons` | `collapse_inactive` | Result                                                                                   |
| ------------ | ------------ | ------------------- | ---------------------------------------------------------------------------------------- |
| `true`       | `true`       | `false`             | Shows every visible space with its label and app icons.                                  |
| `true`       | `true`       | `true`              | Shows the focused space with its label and icons; inactive spaces become compact labels. |
| `true`       | `false`      | `false`             | Shows every visible space as a label.                                                    |
| `true`       | `false`      | `true`              | Shows only the focused space label.                                                      |
| `false`      | `true`       | `false`             | Shows every visible space with app icons.                                                |
| `false`      | `true`       | `true`              | Shows only the focused space with app icons.                                             |
| `false`      | `false`      | either              | Renders no spaces widget and reports a configuration warning.                            |

This table assumes `show_only_focused_label = false`. When it is `true`, inactive labels are removed as well; an inactive space is omitted whenever it would have no visible content.

Disable the widget explicitly instead of configuring it with no visible content:

```toml
[builtins.spaces]
enabled = false
```

EasyBar requires AeroSpace 0.21.0 or newer. See [AeroSpace Integration](../../aerospace.md) and [Troubleshooting](../../runtime/troubleshooting.md#aerospace-widgets-do-not-update) for connection troubleshooting.
