#!/bin/bash

# vim-plug installation script
vim_setup() {
  check_commands curl vim go || return

  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug: installed successfully."
    echo "Please run ':PlugInstall' in Vim to install plugins."
  else
    echo "vim-plug: installed already."
    return
  fi

  if [ ! -f $HOME/go/bin/gopls ]; then
    echo "gopls is not installed. Installing gopls..."
    go install golang.org/x/tools/gopls@latest
  else
    echo "gopls: installed successfully."
  fi

  if [ ! -d ~/.vim/plugged/vim-terraform/ ]; then
    echo "Installing vim-terraform plugin..."
    vim +PlugInstall +qall
  else
    echo "vim-terraform plugin is already installed."
  fi
}

