#!/bin/bash -e

function replace_symlink() {
    source=$1
    target=$2

    target_dir=$(dirname $target)
    mkdir -p $target_dir

    if [[ -L $target ]] || [[ -f $target ]]; then
        unlink $target
    fi

    ln -sf $source $target
}

dotfiles_dir=$(realpath .)
echo "Dotfiles directory: ${dotfiles_dir}"

# Homebrew installation
if ! [[ $(type brew) > /dev/null ]]; then
    echo "Homebrew not found; installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ ${BREW_INSTALL} -eq 1 ]]; then
    brew_dir=${dotfiles_dir}/brew
    echo "Installing Homebrew packages from ${brew_dir}/Brewfile"
    brew bundle install --file ${brew_dir}/Brewfile
    brew bundle cleanup --file ${brew_dir}/Brewfile
fi

# setup zsh configuration
echo "Setting up zsh configuration files..."
zsh_dir=${dotfiles_dir}/zsh
replace_symlink ${zsh_dir}/.zshenv ${HOME}/.zshenv
replace_symlink ${zsh_dir}/.zprofile ${HOME}/.zprofile
replace_symlink ${zsh_dir}/.zshrc ${HOME}/.zshrc
replace_symlink ${zsh_dir}/.zsh_history ${HOME}/.zsh_history

# setup mise configuration
echo "Setting up mise configuration file..."
mise_dir=${dotfiles_dir}/config/mise
replace_symlink "${mise_dir}/config.toml" "${HOME}/.config/mise/config.toml"

# setup other configuration files
echo "Setting up other configuration files..."
replace_symlink ${dotfiles_dir}/wezterm ${HOME}/.config/wezterm
replace_symlink ${dotfiles_dir}/config/sheldon ${HOME}/.config/sheldon
replace_symlink ${dotfiles_dir}/config/starship ${HOME}/.config/starship
replace_symlink ${dotfiles_dir}/config/git ${HOME}/.config/git
replace_symlink ${dotfiles_dir}/config/claude ${HOME}/.config/claude
