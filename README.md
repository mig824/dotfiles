# dotfiles

Personal dev environment config — nvim, tmux, zsh.

## What's included

```
nvim/                    Neovim config (AstroNvim v5)
tmux/.tmux.conf          Tmux config
zsh/.zshrc               Portable zsh config (znap + starship)
zsh/.zshrc.local.example Template for machine-specific config
starship/starship.toml   Starship prompt config
ghostty/config           Ghostty terminal config (macOS only)
install.sh               Automated setup script
```

## Quick start

```bash
git clone git@github.com:mig824/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script automatically:
- Installs dependencies: neovim, tmux, fzf, fd, bat (via brew or apt)
- Creates symlinks for all configs
- Installs [starship](https://starship.rs) prompt
- Installs [znap](https://github.com/marlonrichert/zsh-snap) plugin manager
- Installs [TPM](https://github.com/tmux-plugins/tpm) for tmux
- Syncs nvim plugins headlessly (AstroNvim + Lazy)
- Creates `~/.secrets` with locked permissions

Zsh plugins (autosuggestions, syntax highlighting, z) are auto-cloned by znap on first shell load.

## Post-install

### 1. Machine-specific config

Copy the example and customize:
```bash
cp ~/dotfiles/zsh/.zshrc.local.example ~/.zshrc.local
```

Edit with machine-specific paths and aliases. See the example file for devbox and macOS templates.

### 2. Secrets

Add API keys to `~/.secrets` (created by install script, chmod 600):
```bash
export OPENAI_API_KEY=sk-...
```

This file is sourced by `.zshrc` but excluded from git.

### 3. Neovim plugins

Open nvim and run `:Lazy sync`.

### 4. Tmux plugins

Open tmux and press `prefix + I` to install plugins.

## File organization

### Committed (portable)
| File | Purpose |
|------|---------|
| `zsh/.zshrc` | Shell config that works on any machine |
| `tmux/.tmux.conf` | Tmux config with platform-aware status bar |
| `starship/starship.toml` | Starship prompt config |
| `nvim/` | Full AstroNvim config |

### Not committed (machine-specific)
| File | Purpose |
|------|---------|
| `~/.zshrc.local` | Machine-specific paths, aliases, functions |
| `~/.secrets` | API keys (chmod 600) |

### How changes flow

Everything is symlinked, so edits to `~/.config/nvim/`, `~/.zshrc`, etc. edit the repo directly:
```bash
cd ~/dotfiles
git add .
git commit -m "update nvim config"
git push
```

On the other machine:
```bash
cd ~/dotfiles
git pull
```

Nvim plugins may need a `:Lazy sync` after pulling if `lazy-lock.json` changed.

## FZF integration

Colors are gruvbox-matched. File finding uses `fd`, previews use `bat` with syntax highlighting.

**Shell aliases:**
| Alias | Action |
|-------|--------|
| `gsi` | Fuzzy switch branch |
| `gcof` | Fuzzy switch branch (sorted by most recent) |
| `gaf` | Fuzzy stage files (multi-select with Tab, diff preview) |
| `glf` | Fuzzy browse last 2 weeks of commits → copies full SHA to clipboard |
| `fkill` | Fuzzy kill processes (multi-select with Tab) |
| `lf [dir]` | Mini file manager with bat/tree preview pane |

**Built-in fzf keybindings** (from `~/.fzf.zsh`):
| Key | Action |
|-----|--------|
| `Ctrl-R` | Fuzzy shell history search |
| `Ctrl-T` | Fuzzy file path (bat preview) |
| `Alt-C` | Fuzzy cd into directory (tree preview) |

**Tmux:**
| Key | Action |
|-----|--------|
| `Prefix + f` | Fuzzy switch to any window across all sessions |

## Neovim setup details

### Plugins
- **Motion**: flash.nvim, mini-surround, harpoon
- **Editing**: treesitter-textobjects, yanky.nvim, rainbow-delimiters
- **Git**: diffview.nvim, gitsigns.nvim
- **Diagnostics**: trouble.nvim
- **File management**: oil.nvim (neo-tree disabled)
- **UI**: gruvbox (hard contrast), noice.nvim (centered cmdline), custom heirline statusline

### Key mappings

**General:**
| Key | Action |
|-----|--------|
| `<C-d>` / `<C-u>` | Half-page scroll (centered) |
| `n` / `N` | Search results (centered) |
| `J` | Join lines (cursor stays put) |
| `<Esc>` | Clear search highlight |
| `gp` | Select last pasted text |

**Visual mode:**
| Key | Action |
|-----|--------|
| `J` / `K` | Move selection down/up |
| `<` / `>` | Indent (stays in visual mode) |

**Treesitter textobjects:**
| Key | Action |
|-----|--------|
| `vaf` / `vif` | Select around/inside function |
| `vaa` / `via` | Select around/inside parameter |
| `vac` / `vic` | Select around/inside class |
| `]m` / `[m` | Next/previous function |
| `]a` / `[a` | Next/previous parameter |
| `<Leader>a` / `<Leader>A` | Swap parameter next/previous |

**Search:**
| Key | Action |
|-----|--------|
| `<Leader>fw` | Find words (global) |
| `<Leader>fW` | Find words (current file's directory) |

**Buffer/file:**
| Key | Action |
|-----|--------|
| `]b` / `[b` | Next/previous buffer |
| `<Leader>by` | Copy relative file path |
| `<Leader>bd` | Pick buffer to close |
| `-` | Open parent directory (oil.nvim) |

**Git (leader = space):**
| Key | Action |
|-----|--------|
| `<Leader>gd` | Diff working tree |
| `<Leader>gD` | Diff last commit |
| `<Leader>gh` | File history |
| `<Leader>gH` | Branch history |

**Yanky:** After pasting, `<C-p>` / `<C-n>` cycles through yank history.

**Trouble:** `<Leader>x` prefix for diagnostics lists.

### Platform-specific behavior

- **SSH sessions (devbox)**: OSC 52 clipboard is enabled — yanks sync to Mac clipboard via terminal passthrough
- **Local (Mac)**: OSC 52 is skipped, nvim uses the native system clipboard
- **gopls**: Directory filters for the Dropbox monorepo are in `nvim/lua/plugins/gopls.lua` — harmless on Mac (ignored if the dirs don't exist)

