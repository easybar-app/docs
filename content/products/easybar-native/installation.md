# Install EasyBar Native

EasyBar Native is distributed separately from EasyBar through the `easybar-app/tap` Homebrew tap.

## Install

```bash
brew tap easybar-app/tap
brew install --cask easybar-app/tap/easybar-native
```

The cask installs:

- `/Applications/EasyBarNative.app`;
- the `easybar-native` launcher from the app bundle;
- Lua as a Homebrew dependency when it is not already available.

It does **not** install the EasyBar Calendar agent, Network agent, or `easybar` CLI.

## Launch

```bash
open -a "EasyBar Native"
```

Verify the app and CLI:

```bash
easybar-native --version
/Applications/EasyBarNative.app/Contents/MacOS/EasyBarNative --version
```

## User data

EasyBar Native creates or uses its own paths:

```text
~/.config/easybar-native
~/.local/share/easybar-native
~/.local/state/easybar-native
```

These are independent from `~/.config/easybar`, `~/.local/share/easybar`, and
`~/.local/state/easybar`.

## Upgrade

```bash
brew update
brew upgrade --cask easybar-app/tap/easybar-native
```

Reopen the app if an older process is still running.

## macOS quarantine

Current releases are ad-hoc signed rather than notarized. The Homebrew cask removes the quarantine
attribute from the installed app. For a manually extracted release archive, remove it yourself if
Gatekeeper blocks launch:

```bash
xattr -dr com.apple.quarantine /Applications/EasyBarNative.app
```

## Uninstall

```bash
brew uninstall --cask easybar-app/tap/easybar-native
```

Homebrew removal does not delete Native config, packages, or logs. Remove those directories only
when you intentionally want a complete reset:

```text
~/.config/easybar-native
~/.local/share/easybar-native
~/.local/state/easybar-native
```
