# Applications

This folder contains small utility apps used by my macOS bootstrap setup.

These files are intentionally tracked in git.

## Why this exists

Most applications installed on macOS are **not** tracked here. This folder is for small custom apps that I created to support automation or workflows that are difficult to accomplish with shell scripts alone due to macOS permissions (TCC), LaunchAgents, or other system constraints.

Examples include:

- wrapper apps for scheduled tasks
- utilities launched by `launchd`
- small AppleScript or Automator apps
- workflow helpers used by bootstrap scripts

## Current apps

### Clear Downloads.app

A small wrapper app used by a LaunchAgent to clean stale files from `~/Downloads`.

This exists because macOS protects the Downloads folder and scheduled shell scripts running under `launchd` may not have permission to access it directly. Wrapping the cleanup script in an app allows macOS to grant Downloads access to a specific application instead of broadly granting permissions to `/bin/bash`.

Related script:

```text
~/.config/bin/cleanup_downloads.sh
```

Related LaunchAgent:

```text
~/Library/LaunchAgents/com.macosbootstrap.cleanup-downloads.plist
```

## Reminder to future me

If you add files here, remember:

- They are tracked by git.
- Keep this folder limited to intentional, custom utilities.
- Avoid dropping large downloaded `.app` bundles here unless you actually want them versioned.
