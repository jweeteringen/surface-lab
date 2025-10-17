#!/usr/bin/env bash
set -e

echo "🚀 Installing Surface Lab..."

# Make sure git and curl are installed
if ! command -v git >/dev/null || ! command -v curl >/dev/null; then
  echo "Installing required packages (git, curl)..."
  if command -v sudo >/dev/null; then sudo apt update && sudo apt install -y git curl; else apt update && apt install -y git curl; fi
fi

# Clone or update repo
if [ ! -d "$HOME/projects/surface-lab" ]; then
  mkdir -p "$HOME/projects"
  git clone https://github.com/jweeteringen/surface-lab.git "$HOME/projects/surface-lab"
else
  echo "Updating existing Surface-Lab repo..."
  cd "$HOME/projects/surface-lab" && git pull
fi

# Copy scripts to ~/scripts
mkdir -p "$HOME/scripts"
cp "$HOME/projects/surface-lab/surface-lab.sh" "$HOME/scripts/"
cp "$HOME/projects/surface-lab/missions.txt" "$HOME/scripts/" 2>/dev/null || true
chmod +x "$HOME/scripts/surface-lab.sh"

# Add alias if missing
if ! grep -qxF "alias lab=\"~/scripts/surface-lab.sh\"" "$HOME/.zshrc"; then
  echo -e "\n# Surface Lab\nalias lab=\"~/scripts/surface-lab.sh\"" >> "$HOME/.zshrc"
  echo "✅ Alias lab added to ~/.zshrc"
fi

echo "✅ Surface-Lab installed successfully!"
echo "Run: source ~/.zshrc && lab"
