#!/usr/bin/env bash

# dev-tools/install.sh - Setup symlinks and PATH

REPO_DIR=$(pwd)

# Create symlinks
mkdir -p ~/scripts ~/sources
rm -rf ~/scripts ~/sources
ln -s "$REPO_DIR/scripts" ~/scripts
ln -s "$REPO_DIR/sources" ~/sources

# Update ~/.zshrc
ZSHRC="$HOME/.zshrc"

if ! grep -q 'export PATH="$HOME/scripts:$PATH"' "$ZSHRC"; then
    echo -e "\n# Add custom scripts to PATH\nexport PATH=\"\$HOME/scripts:\$PATH\"" >> "$ZSHRC"
fi

if ! grep -q 'for f in ~/sources/*.zsh; do' "$ZSHRC"; then
    cat <<'ZSH_EOF' >> "$ZSHRC"

# Source all .zsh files in ~/sources
for f in ~/sources/*.zsh; do
    [ -f "$f" ] && source "$f"
done
ZSH_EOF
fi

echo "dev-tools installation complete. Please restart your shell or run 'source ~/.zshrc'."
