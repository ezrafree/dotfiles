#!/usr/bin/env bash

packages=(
  @anthropic-ai/claude-code
  @openai/codex
  np
  yo
  generator-code
)

for package in "${packages[@]}"; do
  if npm list -g "$package" --depth=0 &>/dev/null; then
    echo "==> Already installed: $package"
  else
    echo "==> Installing $package"
    npm install -g "$package"
  fi
done
