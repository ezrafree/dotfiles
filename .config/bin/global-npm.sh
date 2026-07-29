#!/usr/bin/env bash

packages=(
  @openai/codex
  @google/gemini-cli
  @github/copilot
  openclaw
  np
  yo
  generator-code
  @vscode/vsce
  auth0-deploy-cli
)

for package in "${packages[@]}"; do
  if npm list -g "$package" --depth=0 &>/dev/null; then
    echo "==> Already installed: $package"
  else
    echo "==> Installing $package"
    npm install -g "$package"
  fi
done
