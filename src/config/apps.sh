#!/bin/bash

APP_REPOS=(
  "https://github.com/haturatu/ght.git"
  "https://github.com/haturatu/cuckooget.git"
)

declare -A INSTALL_METHODS=(
  ["ght"]="sudo"
  ["cuckooget"]="user"
)
