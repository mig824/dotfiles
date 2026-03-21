#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

info() { echo "  [+] $1"; }
skip() { echo "  [-] $1 (already installed)"; }

echo "=== Installing dotfiles ==="
echo ""

# --- Dependencies ---
echo "Installing dependencies..."
if [[ "$(uname)" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew not found. Install it first: https://brew.sh" >&2
    exit 1
  fi
  for pkg in neovim tmux fzf fd bat tree; do
    if brew list "$pkg" &>/dev/null; then
      skip "$pkg"
    else
      info "Installing $pkg..."
      brew install "$pkg"
    fi
  done
else
  pkgs=()
  for pkg in neovim tmux fzf fd-find bat tree; do
    if dpkg -s "$pkg" &>/dev/null 2>&1; then
      skip "$pkg"
    else
      pkgs+=("$pkg")
    fi
  done
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    info "Installing ${pkgs[*]}..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq "${pkgs[@]}"
  fi
fi
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

# --- Neovim plugins (AstroNvim + Lazy) ---
info "Syncing nvim plugins (headless)..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null
info "Nvim plugins synced"

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
echo "  3. Open tmux and press prefix + I to install plugins"
echo "  4. Open a new shell to load everything"
