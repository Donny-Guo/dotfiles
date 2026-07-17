# dotfiles

(Inspired by [this](https://github.com/vossenwout/pookie-dotfiles/tree/main)) (also reference [dusty-phillips dotfiles](https://github.com/dusty-phillips/dotfiles))

My personal configuration files for neovim, tmux, ghostty, and zsh. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Table of Contents**:

- [dotfiles](#dotfiles)
  - [Structure](#structure)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Adding a new config](#adding-a-new-config)
  - [Linux Maintenance](#linux-maintenance)
  - [Notes](#notes)
    - [Neovim](#neovim)
    - [Zshrc](#zshrc)

## Structure

```
dotfiles/
├── docs/
│   ├── zsh-install.md
│   └── recommended_installation.md
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

or

```bash
sudo apt update && sudo apt install stow
```



## Installation

```bash
git clone https://github.com/Donny-Guo/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow neovim
stow tmux
stow ghostty
stow kitty
# review your .zshrc file first and maybe back it up
# stow zshrc
```

This creates symlinks from the expected config locations to the files in this repo.

## Adding a new config

1. Move the config file/folder into the dotfiles repo, mirroring the home directory structure
2. Run `stow <package>` to create the symlink
3. Commit and push

## Linux Maintenance

- [Recommended Installation Guide & Linux System Maintenance](./docs/recommended_installation.md)

## Notes

### Neovim

- Install nvim: https://neovim.io/doc/install/
- Dependencies:
  - Basic utils: git, make, unzip, C Compiler (gcc) (`sudo apt install build-essential`)
  - ripgrep, fd-find (`sudo apt install ripgrep fd-find`)

### Zshrc

* [Install Zsh on Ubuntu/Debian](./docs/zsh-install.md)
* Install oh-my-zsh: https://github.com/ohmyzsh/ohmyzsh

* install oh-my-zsh plugins: (https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh and https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

  ```bash
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

  Note: `zsh-syntax-highlighting` needs to be put at the last of the plugins array.

* Add config to your own `~/.zshrc` file
