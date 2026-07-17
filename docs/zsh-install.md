# Installing Zsh on Ubuntu/Debian

## Install Zsh

```bash
sudo apt update && sudo apt install zsh
```

## Set Zsh as Default Shell

1. Verify the installation path:

```bash
which zsh
```

2. Change your default shell:

```bash
chsh -s $(which zsh)
```

3. Log out and log back in for the change to take effect.

4. Verify your new shell:

```bash
echo $SHELL
```

## Install Oh-My-Zsh (Recommended)

After switching to zsh, install Oh-My-Zsh:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install Oh-My-Zsh Plugins

```bash
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Note: `zsh-syntax-highlighting` must be placed last in the plugins array in your `.zshrc`.

See [.zshrc](../zshrc/.zshrc) for the full configuration.
