# Define custom plugins directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"

echo "🚀 Starting Zsh setup on Ubuntu..."

# Install Zsh if not installed
if ! command -v zsh &>/dev/null; then
  echo "🔹 Installing Zsh..."
  sudo apt update && sudo apt install -y zsh
else
  echo "✅ Zsh is already installed."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🔹 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh is already installed."
fi

# Ensure plugins directory exists
mkdir -p "$ZSH_CUSTOM"

# Install required plugins
echo "🔹 Installing plugins..."
declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  ["alias-finder"]="https://github.com/tuxified/alias-finder.git"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d "$ZSH_CUSTOM/$plugin" ]; then
    echo "  ➜ Installing $plugin..."
    git clone "${plugins[$plugin]}" "$ZSH_CUSTOM/$plugin"
    elsei
    echo "  ✅ $plugin is already installed."
  fi
done

# Ensure plugins are enabled in .zshrc
echo "🔹 Updating ~/.zshrc..."
if ! grep -q "plugins=(git alias-finder zsh-autosuggestions zsh-syntax-highlighting)" "$HOME/.zshrc"; then
  sed -i.bak 's/^plugins=(.*/plugins=(git alias-finder zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
else
  echo "✅ Plugins already listed in .zshrc."
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔹 Changing default shell to Zsh..."
  chsh -s "$(which zsh)"
  echo "✅ Default shell changed to Zsh. Restart your terminal or log out and log back in."
else
  echo "✅ Zsh is already the default shell."
fi

# Reload .zshrc
echo "🔹 Applying changes..."
source ~/.zshrc

echo "🎉 Zsh setup complete!"
