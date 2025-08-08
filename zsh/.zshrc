export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

HIST_STAMPS="dd/mm/yyyy"

if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ "$TERM" == "xterm-ghostty" ]] && ! infocmp "$TERM" &>/dev/null; then
    export TERM="xterm-256color"
fi

# nvm via brew
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

alias tmux='tmux -f ~/.config/tmux/tmux.conf'

alias gp='git push'
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
alias goclaude='claude --dangerously-skip-permissions'

export STARSHIP_CONFIG="~/.config/starship/starship.toml"

eval "$(starship init zsh)"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/main/.cache/lm-studio/bin"
# End of LM Studio CLI section

