#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

info() { echo "  [+] $1"; }
skip() { echo "  [-] $1 (already installed)"; }

echo "=== Installing dotfiles ==="
echo ""

# --- Symlinks ---
echo "Linking configs..."
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
info "Symlinks created"

# --- Starship ---
if command -v starship &>/dev/null; then
  skip "starship"
else
  info "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin
fi

# --- Znap ---
if [[ -f "$HOME/.zsh-snap/znap.zsh" ]]; then
  skip "znap"
else
  info "Installing znap..."
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/.zsh-snap
fi
mkdir -p ~/.zsh-snap/plugins

# --- TPM ---
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  skip "tpm"
else
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# --- Secrets file ---
if [[ ! -f "$HOME/.secrets" ]]; then
  touch "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  info "Created ~/.secrets (chmod 600)"
else
  skip "~/.secrets"
fi

# --- Done ---
echo ""
echo "=== Done ==="
echo ""
echo "Remaining manual steps:"
echo "  1. Add API keys to ~/.secrets"
echo "  2. Create ~/.zshrc.local with machine-specific config (see zsh/.zshrc.local.example)"
echo "  3. Open nvim and run :Lazy sync"
echo "  4. Open tmux and press prefix + I to install plugins"
echo "  5. Open a new shell to load everything"
