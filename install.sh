#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y htop curl wget vim tmux parallel speedometer git curl wget python3 python3-pip exuberant-ctags

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

cat .bash_aliases >> ~/.bash_aliases
cat .tmux.conf > ~/.tmux.conf
cat .gitignore.user > ~/.gitignore
cat .gitconfig.user > ~/.gitconfig
mkdir -p ~/.atom
cat keymap.cson > ~/.atom/keymap.cson


# Make config directory for Neovim's init.vim
echo '[*] Preparing Neovim config directory ...'
mkdir -p ~/.config/nvim

# Install nvim (and its dependencies: pip3, git), Python 3 and ctags (for tagbar)
echo '[*] App installing Neovim and its dependencies (Python 3 and git), and dependencies for tagbar (exuberant-ctags) ...'
wget https://github.com/neovim/neovim/releases/download/v0.3.7/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/.miniconda
eval "$(~/.miniconda/bin/conda shell.bash hook)"
conda init
source ~/.bashrc

# Install virtualenv to containerize dependencies
echo '[*] Pip installing virtualenv to containerize Neovim dependencies (instead of installing them onto your system) ...'
conda create --yes --name nvim python=3.7
conda activate nvim

# Install pip modules for Neovim within the virtual environment created
echo '[*] Activating virtualenv and pip installing Neovim (for Python plugin support), libraries for async autocompletion support (jedi, psutil, setproctitle), and library for pep8-style formatting (yapf) ...'
pip install neovim==0.2.6 jedi psutil setproctitle yapf
conda deactivate

# Install vim-plug plugin manager
echo '[*] Downloading vim-plug, the best minimalistic vim plugin manager ...'
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# (Optional but recommended) Install a nerd font for icons and a beautiful airline bar (https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts) (I'll be using Iosevka for Powerline)
echo "[*] Downloading patch font into ~/.local/share/fonts ..."
curl -fLo ~/.local/share/fonts/Iosevka\ Term\ Nerd\ Font\ Complete.ttf --create-dirs https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf

# (Optional) Alias vim -> nvim
echo '[*] Aliasing vim -> nvim, remember to source ~/.bashrc ...'
echo "alias vim='nvim'" >> ~/.bashrc

# Enter Neovim and install plugins using a temporary init.vim, which avoids warnings about missing colorschemes, functions, etc
echo -e '[*] Running :PlugInstall within nvim ...'
sed '/call plug#end/q' init.vim > ~/.config/nvim/init.vim
nvim -c ':PlugInstall' -c ':UpdateRemotePlugins' -c ':qall'
rm ~/.config/nvim/init.vim

# Copy init.vim in current working directory to nvim's config location ...
echo '[*] Copying init.vim -> ~/.config/nvim/init.vim'
cp init.vim ~/.config/nvim/

echo -e "[+] Done, welcome to \033[1m\033[92mNeoVim\033[0m! Try it by running: nvim/vim. Want to customize it? Modify ~/.config/nvim/init.vim"

