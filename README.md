# dev-tools

Centralized repository for development scripts, shell configuration, and tooling.

## Structure

- `scripts/`: Executable scripts (automatically added to your PATH).
- `sources/`: Shell (.zsh) configuration files (automatically sourced in ~/.zshrc).

## Installation

Run the provided install script to setup symlinks, merge existing local scripts/sources into the repository, and update your shell configuration:

```bash
cd /mnt/d/git/dev-tools
chmod +x install.sh
./install.sh
```

## Features

- **Automated PATH**: Scripts in `~/scripts` are added to your shell PATH.
- **Auto-Sourcing**: Any `.zsh` file added to `~/sources/` is automatically sourced on shell startup.
- **Backup & Merge**: Existing `~/scripts` and `~/sources` directories are backed up and merged into the repository during installation.
