HIST_STAMPS="dd/mm/yyyy"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# nvm via brew
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

alias tmux='tmux -f ~/.config/tmux/tmux.conf'

alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gl='git log'
gc() {
    if [ $# -eq 0 ]; then
        git commit
    else
        git commit -m "$*"
    fi
}

alias ll='ls -alF'
alias vim='nvim'
export STARSHIP_CONFIG="~/.config/starship/starship.toml"

eval "$(starship init zsh)"

