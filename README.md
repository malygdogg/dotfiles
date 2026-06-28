# dotfiles

Managed with [chezmoi](https://chezmoi.io). WSL Ubuntu + EndeavourOS (Arch).

## What's here

| File | Notes |
|---|---|
| `~/.zshrc` | zsh + Oh My Zsh + fzf config. WSL/Arch template: `fdfind`/`batcat` vs `fd`/`bat` |
| `~/.zshenv` | cargo env |
| `~/.tmux.conf` | Tokyo Night colors, Ctrl+A prefix |
| `~/.gitconfig` | |
| `~/.markdownlint.json` | MD013, MD024, MD060 disabled |
| `~/.config/starship.toml` | |
| `~/.config/nvim/` | LazyVim config |
| `~/.config/lazygit/config.yml` | |
| `~/.config/yazi/` | |
| `~/.claude/statusline.sh` | Claude Code status bar |
| `~/.claude/settings.json` | Claude Code settings |

## Install

### Prerequisites

Install these before applying dotfiles:

```sh
# zsh
sudo apt install zsh  # Ubuntu
sudo pacman -S zsh    # Arch

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# OMZ plugins (clone into custom/plugins)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# starship
curl -sS https://starship.rs/install.sh | sh

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# fd + bat
sudo apt install fd-find bat   # Ubuntu (fdfind, batcat)
sudo pacman -S fd bat          # Arch (fd, bat)

# Neovim (LazyVim will bootstrap on first launch)
# tmux, lazygit, yazi per distro
```

### Apply dotfiles

```sh
chezmoi init --apply malygdogg
```

### Update after changes

```sh
chezmoi update
```

## Workflow

```sh
# Edit a managed file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply pending changes
chezmoi apply

# After editing source directly, push changes
chezmoi cd
git add -A && git commit -m "..." && git push
```
