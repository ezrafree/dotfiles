#!/usr/bin/env bash

mas_apps=(
  "497799835:Xcode"
  "6714467650:Perplexity"
)

installed=$(mas list)

for entry in "${mas_apps[@]}"; do
  id="${entry%%:*}"
  name="${entry##*:}"
  if echo "$installed" | grep -q "^$id"; then
    echo "==> Already installed: $name"
  else
    echo "==> Installing $name"
    mas install "$id" || true
  fi
done
