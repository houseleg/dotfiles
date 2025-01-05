dotfiles_dir=$(realpath .)

bindkey -d

bindkey '^[a' vi-beginning-of-line
bindkey '^[g' vi-end-of-line
bindkey '^[e' vi-forward-blank-word-end

bindkey '^[u' kill-whole-line
bindkey '^[w' vi-backward-kill-word

bindkey '^[f' vi-forward-word
bindkey '^[b' vi-backward-word

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-style unspecified
zstyle ':zle:*' word-chars " ÷:@+|."

if [[ $TERM_PROGRAM == "WezTerm" ]]; then
    path=(/Applications/WezTerm.app/Contents/MacOS $path)
fi

path=(${HOME}/.local/bin $path)

if [[ -f "${dotfiles_dir}/google-cloud-sdk/path.zsh.inc" ]]; then
    . "${dotfiles_dir}/google-cloud-sdk/path.zsh.inc";
fi

_zcompile() {
    if [[ ${+NO_CACHE} -eq 1 ]]; then
        SHELDON_NO_CACHE=1
        STARSHIP_NO_CACHE=1
        FZF_NO_CACHE=1
        MISE_NO_CACHE=1
    fi

    if [[ $(type sheldon) > /dev/null ]]; then
        if [[ ${+SHELDON_NO_CACHE} -eq 1 || ! -f /tmp/sheldon.cache || $(find /tmp/sheldon.cache -mtime +1) ]]; then
            echo "creating sheldon cache"
            sheldon source > /tmp/sheldon.cache
            zcompile /tmp/sheldon.cache
        fi
        source /tmp/sheldon.cache
    fi

    if [[ $(type starship) > /dev/null ]]; then
        if [[ ${+STARSHIP_NO_CACHE} -eq 1 || ! -f /tmp/starship.cache || $(find /tmp/starship.cache -mtime +1) ]]; then
            echo "creating starship cache"
            starship init zsh > /tmp/starship.cache
            zcompile /tmp/starship.cache
        fi
        source /tmp/starship.cache
    fi

    if [[ $(type fzf) > /dev/null ]]; then
        if [[ ${+FZF_NO_CACHE} -eq 1 || ! -f /tmp/fzf.cache || $(find /tmp/fzf.cache -mtime +1) ]]; then
            echo "creating fzf cache"
            fzf --zsh > /tmp/fzf.cache
            zcompile /tmp/fzf.cache
        fi
        source /tmp/fzf.cache
    fi

    if [[ $(type mise) > /dev/null ]]; then
        if [[ ${+MISE_NO_CACHE} -eq 1 || ! -f /tmp/mise.cache || $(find /tmp/mise.cache -mtime +1) ]]; then
            echo "creating mise cache"
            mise activate zsh > /tmp/mise.cache
            zcompile /tmp/mise.cache
        fi
        source /tmp/mise.cache
    fi
}
_zcompile

_compinit() {
    # if [[ $(type sheldon) > /dev/null ]]; then
    #     sheldon completions --shell zsh
    # fi

    # if [[ $(type starship) > /dev/null ]]; then
    #     starship completions zsh
    # fi

    # if [[ $(type pipx) > /dev/null ]]; then
    #     eval "$(register-python-argcomplete pipx)"
    # fi

    # if [[ $(type gh) > /dev/null ]]; then
    #     gh completion -s zsh > ${HOMEBREW_PREFIX}/share/zsh/site-functions/_gh
    # fi

    if [[ $(type brew) > /dev/null ]]; then
        fpath=(${HOMEBREW_PREFIX}/share/zsh/site-functions $fpath)
    fi

    if [[ $(type wezterm) > /dev/null ]]; then
        if ! [[ -d ${HOME}/.wezterm/completions ]]; then
            mkdir -p ${HOME}/.wezterm/completions
            wezterm shell-completion --shell zsh > ${HOME}/.wezterm/completions/_wezterm
        fi
        fpath=(${HOME}/.wezterm/completions $fpath)
    fi

    # if [[ $(type gcloud) > /dev/null ]]; then
    #     . "${dotfiles_dir}/google-cloud-sdk/completion.zsh.inc"
    # fi

    autoload -Uz compinit
    if [[ ${+COMPINIT_NO_CACHE} -eq 1 || ! -f /tmp/.zcompdump ]]; then
        echo "creating dump file"
        compinit -d /tmp/.zcompdump
        compdump
    else
        compinit -C -d /tmp/.zcompdump
    fi
}
_compinit

alias g='repo=$(ghq root)/$(ghq list | fzf --reverse) && cd $repo'
alias gc='repo=$(ghq root)/$(ghq list | fzf --reverse) && cursor $repo'
alias gv='repo=$(ghq root)/$(ghq list | fzf --reverse) && code $repo'
alias mise-select='(){[[ -z $1 ]] && return 1 || version=$(mise ls-remote "$1" | sort -rV | fzf --reverse) && mise use "$1@$version"}'
