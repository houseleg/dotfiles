#!/bin/bash -e

dotfiles_dir=$(realpath .)

if [[ ${BREW_INSTALL} -eq 1 ]]; then
    if ! [[ $(type brew) > /dev/null ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew_dir=${dotfiles_dir}/brew
    brew bundle install --file ${brew_dir}/Brewfile
    brew bundle cleanup --file ${brew_dir}/Brewfile
fi
