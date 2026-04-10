#!/usr/bin/env bash

# dev-tools/install.sh - Setup symlinks and PATH

set -e

REPO_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dev-tools.backup.$(date +%Y%m%d_%H%M%S)"

# Target directories to symlink
# Format: <target_path> <type: scripts|sources|commands>
TARGETS=(
    "$HOME/scripts scripts"
    "$HOME/sources sources"
    "$HOME/commands commands"
)

echo "Starting dev-tools installation..."

mkdir -p "$BACKUP_DIR"

# Setup Symlinks and Backup Existing Data
for item in "${TARGETS[@]}"; do
    read -r target type <<< "$item"
    repo_source="$REPO_DIR/$type"
    
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing directory: $target"
        backup_path="$BACKUP_DIR/$(basename "${target//\//_}")"
        mkdir -p "$backup_path"
        cp -rp "$target"/. "$backup_path/" 2>/dev/null || true
        
        # Merge content into repo
        echo "Merging $target into $repo_source..."
        cp -rp "$target"/. "$repo_source/" 2>/dev/null || true
        
        rm -rf "$target"
    elif [ -L "$target" ]; then
        echo "Updating existing symlink: $target"
        rm "$target"
    fi

    echo "Creating symlink: $target -> $repo_source"
    ln -s "$repo_source" "$target"
done

# Update ~/.zshrc
ZSHRC="$HOME/.zshrc"
mkdir -p "$(dirname "$ZSHRC")"
touch "$ZSHRC"

# Add scripts to PATH
if ! grep -q 'export PATH="$HOME/scripts:$PATH"' "$ZSHRC"; then
    echo -e "\n# Add custom scripts to PATH\nexport PATH=\"\$HOME/scripts:\$PATH\"" >> "$ZSHRC"
    echo "Added ~/scripts to PATH in $ZSHRC"
fi

# Add commands to PATH (if they contain executables)
if ! grep -q 'export PATH="$HOME/commands:$PATH"' "$ZSHRC"; then
    echo -e "\n# Add custom commands to PATH\nexport PATH=\"\$HOME/commands:\$PATH\"" >> "$ZSHRC"
    echo "Added ~/commands to PATH in $ZSHRC"
fi

if ! grep -q 'for f in ~/sources/*.zsh; do' "$ZSHRC"; then
    cat <<'ZSH_EOF' >> "$ZSHRC"

# Source all .zsh files in ~/sources
for f in ~/sources/*.zsh; do
    [ -f "$f" ] && source "$f"
done
ZSH_EOF
    echo "Added auto-sourcing of ~/sources/*.zsh in $ZSHRC"
fi

# Clean up empty backup dir
if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    rmdir "$BACKUP_DIR"
else
    echo "Backups created in: $BACKUP_DIR"
fi

echo "dev-tools installation complete. Please restart your shell or run 'source ~/.zshrc'."
