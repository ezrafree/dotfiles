# global-mas.sh

declare -A apps=(
  ["Xcode"]="497799835"
  ["Perplexity"]="6714467650"
)

installed=$(mas list)

for name in "${!apps[@]}"; do
  id="${apps[$name]}"
  if echo "$installed" | grep -q "^$id"; then
    echo "==> Already installed: $name"
  else
    echo "==> Installing $name"
    mas install "$id"
  fi
done
