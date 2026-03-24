#!/bin/bash

vim_setup() {
  check_commands curl vim go || return

  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    log_info "vim-plug: installed successfully."
    log_info "Please run ':PlugInstall' in Vim to install plugins."
  else
    log_info "vim-plug: installed already."
  fi

  if [ ! -f "$HOME/go/bin/gopls" ]; then
    log_info "gopls is not installed. Installing gopls..."
    go install golang.org/x/tools/gopls@latest
  else
    log_info "gopls: installed successfully."
  fi

  if [ ! -d "$HOME/.vim/plugged/vim-terraform/" ]; then
    log_info "Installing vim plugins..."
    vim +PlugInstall +qall
  else
    log_info "vim-terraform plugin is already installed."
  fi
}
