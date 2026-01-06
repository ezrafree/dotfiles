# dotfiles

This is a repository of my home directory's dotfiles that I want to share across multiple systems.

The goal here is to only track certain files in the home directory, so the `.gitignore` ignores everything by default and then un-ignore specific files.

This repository tracks my `vim` configuration files, my `zsh` configuration files, and some other dotfiles in my home directory.

## Install Instructions

Change into your home directory

```sh
cd ~
```

Initialize a new git repository

```sh
git init
```

Add a remote repository

```sh
git remote add origin git@github.com:ezrafree/dotfiles.git
```

Pull down the repository

```sh
git pull origin main
```

> Please Note: If you have a customized `~/.vimrc` or `~/.vim/` directory, you'll want to back those up before running the above commands.

Then install the `fast-syntax-highlighting` and `zsh-autosuggestions` plugins

```sh
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.zsh/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
```

Finally, install `powerlevel10k`

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

### Configure Git User

If you're a contributor with commit access, update your username and email for this repository:

```sh
cd ~ && git config user.name "Your Name" && git config user.email your@email.com
```

## Configure

Create `~/.config/gitconfig` which will be included by `~/.gitconfig` (your global git config):

```sh
mkdir -p ~/.config/ && vi ~/.config/gitconfig
```

Add the following contents:

```sh
[user]
  name = "Your Name"
  email = "username@hostname.com"
```

> You can add any other custom configurations that you don't want to track in the repository here, too.

## Config Files

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

### Configure Global Gitignore

Add the following to your `~/.gitconfig` to enable the global gitignore file.

```sh
[core]
  excludesfile = ~/.gitignore_global
```

## Uninstall Instructions

To uninstall, you can simply delete the `.git` directory

```sh
rm -rfv ~/.git/
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
