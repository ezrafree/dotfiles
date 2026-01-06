#!/bin/sh

## backup VS Code extensions...

mkdir -p ~/Preferences/vscode
cd ~/Preferences/vscode
code --list-extensions | xargs -L 1 echo code --install-extension > install-extensions.sh

# backup settings.json...

cd ~/Library/Application\ Support/Code/User/
tar -czf vscode-settings.tar.gz *.json
mv vscode-settings.tar.gz ~/Preferences/vscode

# eof
