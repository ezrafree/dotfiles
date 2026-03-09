# global-npm.sh

packages=(
  @anthropic-ai/claude-code
  @openai/codex
  corepack
)

for package in "${packages[@]}"; do
  if npm list -g "$package" --depth=0 &>/dev/null; then
    echo "==> Already installed: $package"
  else
    echo "==> Installing $package"
    npm install -g "$package"
  fi
done
