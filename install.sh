#!/bin/bash -e

dotfiles_dir=$(realpath .)

function replace_symlink() {
    source=$1
    target=$2

    target_dir=$(dirname $target)
    mkdir -p $target_dir

    if [[ -L $target ]]; then
        rm $target
    fi

    ln -sf $source $target
}

if [[ ${BREW_INSTALL} -eq 1 ]]; then
    if ! [[ $(type brew) > /dev/null ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew_dir=${dotfiles_dir}/brew
    brew bundle install --file ${brew_dir}/Brewfile
    brew bundle cleanup --file ${brew_dir}/Brewfile
fi

replace_symlink ${dotfiles_dir}/.zshenv ${HOME}/.zshenv
replace_symlink ${dotfiles_dir}/zsh ${HOME}/.config/zsh
replace_symlink ${dotfiles_dir}/sheldon ${HOME}/.config/sheldon
replace_symlink ${dotfiles_dir}/git ${HOME}/.config/git
