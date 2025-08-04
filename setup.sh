#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Install prerequisites for Homebrew
echo "📦 Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    git \
    ca-certificates

# Install Homebrew
echo "🍺 Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
# echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
# echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install Homebrew packages
echo "📦 Installing Homebrew packages..."

# Core development tools
brew install \
    neovim \
    starship \
    zsh \
    tmux \
    ripgrep \
    fd \
    tree \
    jq 

echo "🔧 Configuring shell..."

# Set zsh as default shell if it's not already
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# Initialize starship
if ! grep -q "starship init" ~/.zshrc; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

# Setup fzf key bindings and completion
if command -v fzf > /dev/null; then
    echo "Setting up fzf..."
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

echo "✅ Development environment setup complete!"
echo "💡 Run 'source ~/.zshrc' or restart your shell to apply changes"
