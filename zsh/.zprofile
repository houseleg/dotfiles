if [[ $(type brew) > /dev/null ]]; then
    eval "$(brew shellenv)"
fi

if [[ $(type mise) > /dev/null ]]; then
    eval "$(mise activate zsh --shims)"
fi

export EDITOR="vim"
export MANPAGER="col -bx | bat -p -l man --color=always | less -FXR"
