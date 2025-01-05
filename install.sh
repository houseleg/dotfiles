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

if ! [[ $(type gcloud) > /dev/null ]]; then
    echo "google-cloud-sdk not found"
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz
    tar -xvf google-cloud-cli-darwin-arm.tar.gz
    ./google-cloud-sdk/install.sh
    ./google-cloud-sdk/bin/gcloud init
fi

replace_symlink ${dotfiles_dir}/.zshenv ${HOME}/.zshenv
replace_symlink ${dotfiles_dir}/zsh ${HOME}/.config/zsh
replace_symlink ${dotfiles_dir}/zsh/.zshrc ${HOME}/.zshrc
replace_symlink ${dotfiles_dir}/sheldon ${HOME}/.config/sheldon
replace_symlink ${dotfiles_dir}/starship ${HOME}/.config/starship
replace_symlink ${dotfiles_dir}/git ${HOME}/.config/git
