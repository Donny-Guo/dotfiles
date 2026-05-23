# dotfiles

(Inspired by [this](https://github.com/vossenwout/pookie-dotfiles/tree/main)) (also reference [dusty-phillips dotfiles](https://github.com/dusty-phillips/dotfiles))

My personal configuration files for neovim, tmux, ghostty, and zsh. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── neovim/.config/nvim/
├── tmux/.tmux.conf
├── ghostty/.config/ghostty/config
├── kitty/.config/kitty/config
└── zshrc/.zshrc
```

## Requirements

```bash
brew install stow
```

## Installation

```bash
git clone https://github.com/Donny-Guo/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow neovim
stow tmux
stow ghostty
stow kitty
stow zshrc
```

This creates symlinks from the expected config locations to the files in this repo.

## Adding a new config

1. Move the config file/folder into the dotfiles repo, mirroring the home directory structure
2. Run `stow <package>` to create the symlink
3. Commit and push

## Neovim

- Dependencies:
  - Basic utils: git, make, unzip, C Compiler (gcc) (`sudo apt install build-essential`)
  - ripgrep, fd-find (`sudo apt install ripgrep fd-find`)
