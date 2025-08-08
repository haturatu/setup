#!/bin/bash

# Git configuration setup
git_setup() {
  check_commands git || return

  echo "Setting up Git configuration..."
  git config --global user.name "$GIT_USER"
  git config --global user.email "$GIT_EMAIL"
}

