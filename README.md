# dotfiles

This is a repository of my home directory's dotfiles that I want to share across multiple systems.

The goal here is to only track certain files in the home directory, so the `.gitignore` ignores everything by default and then un-ignore specific files.

This repository tracks my `vim` configuration files, my `zsh` configuration files, and some other dotfiles in my home directory.

## Install Instructions

Change into your home directory

```sh
cd ~
```

Clone the bare directory

```sh
git clone --bare git@github.com:ezrafree/dotfiles.git ~/.dotfiles
```

Prevent Git from showing everything in your home directory:

```sh
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
```

Check out the dotfiles

```sh
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
```

Now that you've checked out the repo, your dotfiles are being tracked.

Use `dotfiles` instead of `git`, ie.:

```sh
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "Update zsh config"
```

> Please Note: If you have a customized `~/.vimrc` or `~/.vim/` directory, you'll want to back those up before running the above commands.

Then install the `fast-syntax-highlighting` and `zsh-autosuggestions` plugins

```sh
brew install zsh-fast-syntax-highlighting
brew install zsh-autosuggestions
```

Install Meslo font

```sh
brew install --cask font-meslo-for-powerlevel10k
```

Configure iTerm2 to use the MesloLGS NF (aka NerdFont)

```sh
Settings > Profiles > Text > Font
```

Install `powerlevel10k`

```sh
brew install powerlevel10k
```

Configure `powerlevel10k`

```sh
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

### Configure Git User

Update your username and email for this repository:

```sh
cd ~ && dotfiles config user.name "Ezra Free" && dotfiles config user.email ezrafree@gmail.com
```

### Install Vimplug

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Run `vi` and inside of Vim run:

```sh
:PlugInstall
```

## Configure

Create `~/.config/gitconfig` which will be included by `~/.gitconfig` (your global git config):

```sh
mkdir -p ~/.config/ && vi ~/.config/gitconfig
```

Add the following contents to `~/.config/gitconfig`:

```sh
[user]
  name = "Ezra Free"
  email = "ezrafree@gmail.com"
```

> You can add any other custom configurations that you don't want to track in the repository here, too.

## Which Files Are Included

## Vim

Any `.vim` files in the `~/.vim/settings/` directory will be automatically sourced.

To add your own customized configuration directives, simply add new `.vim` files to the `~/.vim/settings/` directory.

> Be sure to not edit any of the tracked files (listed below), otherwise you won't be able to use `git pull` to update.

The following is the list of files in the `~/.vim/` directory which are tracked by this repository.

```none
.vim/
├── colors/
│   └── molokai.vim
└── settings/
    ├── 00-defaults.vim
    ├── 01-search.vim
    ├── 02-swapfiles.vim
    ├── 03-persistundo.vim
    ├── 04-indentation.vim
    ├── 05-markdown.vim
    ├── 06-nerdtree.vim
    ├── 07-plugins.vim
    ├── 08-userinterface.vim
    ├── 09-pluginsetup.vim
    ├── 10-keymappings.vim
    └── markdown-preview.css
```

## Neovim

The `init.vim` file in the `~/.config/nvim/` directory is part of this repo.

> Be sure to not edit any of the tracked files (listed below), otherwise you won't be able to use `git pull` to update.

The following is the list of files in the `~/.config/nvim/` directory which are tracked by this repository.

```none
.config/
└── nvim/
    └── init.vim
```

## Zsh

Any `.zsh` files in the `~/.zsh/config/` directory will be automatically sourced.

To add your own customized configuration directives, simply add new `.zsh` files to the `~/.zsh/config/` directory.

> Be sure to not edit any of the tracked files (listed below), otherwise you won't be able to use `git pull` to update.

The following is the list of files in the `~/.zsh/` directory which are tracked by this repository.

```none
.zsh/
└── config/
   ├── 00-path.zsh
   ├── 01-manpages.zsh
   ├── 02-plugins.zsh
   ├── 03-ohmyzsh.zsh
   ├── 04-alias.zsh
   └── README.md
```

### Profiling Zsh

If you need to profile `zsh` load times, you can temporarily load the internal `zprof` module. This can be helpful in determining which plugins are adding the most load time.

Be sure and remove this line from the config when you're done using the `zprof` command.

```sh
# for profiling zsh (remove when not in use)
zmodload zsh/zprof
```

## Other Configs

The following is the list of other config files in the `~/` directory which are tracked by this repository.

```none
~/
├── .config/nvim/init.vim
├── .gitconfig
├── .gitignore_global
├── .hushlogin
├── .p10k.zsh
├── .phoenix.js
├── .vimrc
├── .zshrc
└── README.md
```

## Uninstall Instructions

To uninstall, you can simply delete the `.dotfiles` directory

```sh
rm -rfv ~/.dotfiles/
```

However, to reinstall again, you'll need to first remove the files this repository tracks.

Create a new file at `~/uninstall_dotfiles.sh` and add the following contents:

```sh
#!/bin/sh

rm -rfv ~/.git/

declare -a files=(
  ".config/nvim/init.vim"
  ".gitconfig"
  ".gitignore"
  ".gitignore_global"
  ".hushlogin"
  ".p10k.zsh"
  ".vim/colors/molokai.vim"
  ".vim/settings/00-defaults.vim"
  ".vim/settings/01-search.vim"
  ".vim/settings/02-swapfiles.vim"
  ".vim/settings/03-persistundo.vim"
  ".vim/settings/04-indentation.vim"
  ".vim/settings/05-markdown.vim"
  ".vim/settings/06-nerdtree.vim"
  ".vim/settings/07-plugins.vim"
  ".vim/settings/08-userinterface.vim"
  ".vim/settings/09-pluginsetup.vim"
  ".vim/settings/10-keymappings.vim"
  ".vim/settings/markdown-preview.css"
  ".vimrc"
  ".zsh/config/00-config.zsh"
  ".zsh/config/00-path.zsh"
  ".zsh/config/01-manpages.zsh"
  ".zsh/config/02-plugins.zsh"
  ".zsh/config/03-ohmyzsh.zsh"
  ".zsh/config/04-alias.zsh"
  ".zsh/config/README.md"
  ".zshrc"
  "README.md"
)

fileslength=${#files[@]}

for (( i=0; i<${fileslength}; i++ ));
do
  rm -v "${files[$i]}"
done
```

Make the script executable

```sh
chmod +x ~/uninstall_dotfiles.sh
```

And finally, execute the script

```sh
./uninstall_dotfiles
```

Now you can proceed with the install instructions above to reinstall.
