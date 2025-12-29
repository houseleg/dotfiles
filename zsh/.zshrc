local dotfiles_dir=$(dirname $(dirname $(realpath ${(%):-%x})))

bindkey -d
bindkey '^[a' vi-beginning-of-line
bindkey '^[g' vi-end-of-line
bindkey '^[e' vi-forward-blank-word-end
bindkey '^[u' kill-whole-line
bindkey '^[w' vi-backward-kill-word
bindkey '^[f' vi-forward-word
bindkey '^[b' vi-backward-word

DIRSTACKSIZE=100

HISTFILE=$HOME/.zsh_history
HISTORY_IGNORE="(cd|(cd *)|exit|ls|(ls *)|pwd)"
HISTSIZE=10000
SAVEHIST=10000

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt HIST_ALLOW_CLOBBER
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY_TIME
setopt NO_BEEP

autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-style unspecified
zstyle ':zle:*' word-chars " ÷:@+|."

autoload -Uz compinit
autoload -U +X bashcompinit && bashcompinit

zmodload zsh/zutil

function __load_tools() {
    function __load_tool_cache() {
        local -A name
        local -A generator
        local -A no_cache
        local -A cache_ttl_days

        zparseopts -D -F -K -M -- \
            -name:=name \
            -generator:=generator \
            -no-cache:=no_cache \
            -cache-ttl-days:=cache_ttl_days \
            || return 1;

        if [[ ! $(type $name) > /dev/null ]]; then
            echo "${name} not found; skipping cache load" >&2
            return 1;
        fi

        if [[ ${no_cache} -eq 1 || ! -f /tmp/${name}.cache || $(find /tmp/${name}.cache -mtime +${cache_ttl_days:-1}) ]]; then
            echo "creating ${name} cache..."
            if ! eval "${generator}" > /tmp/${name}.cache; then
                echo "failed to create ${name} cache" >&2
                rm -f /tmp/${name}.cache
                return 1;
            fi
            zcompile /tmp/${name}.cache
            echo "${name} cache created"
        fi
        source /tmp/${name}.cache
        return 0;
    }

    if [[ ${+NO_CACHE} -eq 1 ]]; then
        NO_CACHE_MISE=1
        NO_CACHE_SHELDON=1
        NO_CACHE_STARSHIP=1
        NO_CACHE_FZF=1
    fi

    __load_tool_cache \
        --name mise \
        --generator "mise activate zsh" \
        --no-cache ${NO_CACHE_MISE:-0} \
        --cache-ttl-days 1;

    __load_tool_cache \
        --name sheldon \
        --generator "sheldon source" \
        --no-cache ${NO_CACHE_SHELDON:-0} \
        --cache-ttl-days 1;

    __load_tool_cache \
        --name starship \
        --generator "starship init zsh" \
        --no-cache ${NO_CACHE_STARSHIP:-0} \
        --cache-ttl-days 1;

    __load_tool_cache \
        --name fzf \
        --generator "fzf --zsh" \
        --no-cache ${NO_CACHE_FZF:-0} \
        --cache-ttl-days 1;
}
__load_tools

function __load_completions() {
    function __load_completion_cache() {
        local -A name
        local -A generator
        local -A no_cache
        local -A cache_ttl_days

        zparseopts -D -F -K -M -- \
            -name:=name \
            -generator:=generator \
            -no-cache:=no_cache \
            -cache-ttl-days:=cache_ttl_days \
            || return 1;

        if [[ ! $(type $name) > /dev/null ]]; then
            echo "${name} not found; skipping cache load" >&2
            return 1;
        fi

        if [[ ${no_cache} -eq 1 || ! -f /tmp/${name}.completion.cache || $(find /tmp/${name}.completion.cache -mtime +${cache_ttl_days:-1}) ]]; then
            echo "creating ${name} completion cache..."
            if ! eval "${generator}" > /tmp/${name}.completion.cache; then
                echo "failed to create ${name} cache" >&2
                rm -f /tmp/${name}.completion.cache
                return 1;
            fi
            zcompile /tmp/${name}.completion.cache
            echo "${name} cache created"
        fi
        source /tmp/${name}.completion.cache
        return 0;
    }

    local completion_cache_dir=${dotfiles_dir}/zsh/completions
    local compdump_cache=${completion_cache_dir}/.zcompdump
    mkdir -p ${completion_cache_dir}

    if [[ ${+NO_CACHE_COMPLETION} -eq 1 ]]; then
        NO_CACHE_COMPINIT=1
        NO_CACHE_COMPLETION_WEZTERM=1
        NO_CACHE_COMPLETION_SHELDON=1
        NO_CACHE_COMPLETION_STARSHIP=1
        NO_CACHE_COMPLETION_GCLOUD=1
        NO_CACHE_COMPLETION_GH=1
    fi

    fpath=(${completion_cache_dir} $fpath)
    if [[ $(type brew) > /dev/null ]]; then
        fpath=(${HOMEBREW_PREFIX}/share/zsh/site-functions $fpath)
    fi

    if [[ ${NO_CACHE_COMPINIT:-0} -eq 1 || ! -f ${compdump_cache} ]]; then
        echo "creating compinit cache..."
        compinit -d ${compdump_cache}
        compdump
        echo "compinit cache created"
    else
        compinit -C -d ${compdump_cache}
    fi

    __load_completion_cache \
        --name wezterm \
        --generator "wezterm shell-completion --shell zsh" \
        --no-cache ${NO_CACHE_COMPLETION_WEZTERM:-0} \
        --cache-ttl-days 1;

    __load_completion_cache \
        --name sheldon \
        --generator "sheldon completions --shell zsh" \
        --no-cache ${NO_CACHE_COMPLETION_SHELDON:-0} \
        --cache-ttl-days 1;

    __load_completion_cache \
        --name starship \
        --generator "starship completions zsh" \
        --no-cache ${NO_CACHE_COMPLETION_STARSHIP:-0} \
        --cache-ttl-days 1;

    __load_completion_cache \
        --name gcloud \
        --generator "cat $CLOUDSDK_ROOT_DIR/completion.zsh.inc" \
        --no-cache ${NO_CACHE_COMPLETION_GCLOUD:-0} \
        --cache-ttl-days 1;

    __load_completion_cache \
        --name gh \
        --generator "gh completion -s zsh" \
        --no-cache ${NO_CACHE_COMPLETION_GH:-0} \
        --cache-ttl-days 1;
}
__load_completions

alias g='repo=$(ghq root)/$(ghq list | fzf --reverse) && cd $repo'
alias gc='repo=$(ghq root)/$(ghq list | fzf --reverse) && cursor $repo'
alias gv='repo=$(ghq root)/$(ghq list | fzf --reverse) && code $repo'
