#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up development environment...${NC}"

# Get the directory where this script is located (dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "${YELLOW}📁 Dotfiles directory: $DOTFILES_DIR${NC}"

# other than git and certs, all of these are used by neovim and faster to install with apt than as implicit brew dependencies
echo -e "${BLUE}📦 Installing prerequisites...${NC}"
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    git \
    locales \
    ca-certificates \
    libncurses-dev \
    libreadline-dev \
    zlib1g-dev \
    libxml2-dev \
    gettext \
    libuv1-dev \
    libicu-dev \
    libacl1-dev \
    libunistring-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

sudo locale-gen en_US.UTF-8

echo -e "${BLUE}🍺 Installing Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to current session PATH
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

echo -e "${BLUE}📦 Installing Homebrew packages...${NC}"
brew install \
    neovim \
    starship \
    zsh \
    tmux \
    ripgrep \
    fd \
    tree \
    jq

echo -e "${BLUE}📦 Installing Claude Code...${NC}"
if ! command -v claude >/dev/null 2>&1; then
    timeout 600 curl -fsSL https://claude.ai/install.sh | bash || {
        echo "Installation timed out, retrying..."
        pkill -f claude 2>/dev/null || true
        sleep 5
        curl -fsSL https://claude.ai/install.sh | bash
    }
else
    echo "Claude already installed: $(which claude)"
fi

echo -e "${BLUE}🔧 Configuring shell environment...${NC}"

touch ~/.zshrc

if ! grep -q "/home/linuxbrew/.linuxbrew/bin/brew shellenv" ~/.zshrc; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${YELLOW}🐚 Setting zsh as default shell...${NC}"
    sudo chsh -s "$(which zsh)" "$USER"
fi

echo -e "${BLUE}⭐ Setting up Starship...${NC}"
if [ -f "$DOTFILES_DIR/starship/starship.toml" ]; then
    mkdir -p ~/.config
    ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
    echo -e "${GREEN}✅ Starship config linked${NC}"
else
    echo -e "${RED}⚠️  Starship config not found at $DOTFILES_DIR/starship/starship.toml${NC}"
fi

if ! grep -q "starship init zsh" ~/.zshrc; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

echo -e "${BLUE}🔧 Setting up Neovim...${NC}"
if [ -d "$DOTFILES_DIR/nvim" ]; then
    mkdir -p ~/.config
    ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
    echo -e "${GREEN}✅ Neovim config linked${NC}"
else
    echo -e "${RED}⚠️  Neovim config not found at $DOTFILES_DIR/nvim${NC}"
fi

echo -e "${BLUE}🖥️  Setting up Tmux...${NC}"
if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
    ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
    echo -e "${GREEN}✅ Tmux config linked${NC}"
else
    echo -e "${RED}⚠️  Tmux config not found at $DOTFILES_DIR/tmux/tmux.conf${NC}"
fi

echo -e "${BLUE}👻 Setting up Ghostty...${NC}"
if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    mkdir -p ~/.config/ghostty
    ln -sf "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
    echo -e "${GREEN}✅ Ghostty config linked${NC}"
else
    echo -e "${RED}⚠️  Ghostty config not found at $DOTFILES_DIR/ghostty/config${NC}"
fi

echo -e "${BLUE}🐚 Setting up Zsh configuration...${NC}"
if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
    # Backup existing zshrc if it exists and isn't empty
    if [ -s ~/.zshrc ] && [ ! -f ~/.zshrc.backup ]; then
        cp ~/.zshrc ~/.zshrc.backup
        echo -e "${YELLOW}📋 Backed up existing .zshrc to .zshrc.backup${NC}"
    fi
    # Append custom zshrc content
    echo "# Dotfiles zsh configuration" >> ~/.zshrc
    cat "$DOTFILES_DIR/zsh/.zshrc" >> ~/.zshrc
    echo -e "${GREEN}✅ Zsh configuration added${NC}"
elif [ -d "$DOTFILES_DIR/zsh" ]; then
    echo -e "${YELLOW}⚠️  Found zsh directory but no .zshrc file${NC}"
else
    echo -e "${YELLOW}⚠️  No zsh configuration found${NC}"
fi

# Source the new zsh configuration in current session if running in zsh
if [ "$0" = "zsh" ] || [ -n "$ZSH_VERSION" ]; then
    echo -e "${BLUE}🔄 Reloading zsh configuration...${NC}"
    source ~/.zshrc
fi

echo -e "${GREEN}✅ Development environment setup complete!${NC}"


