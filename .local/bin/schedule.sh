#!/usr/bin/env zsh

# Source aliases
source $HOME/.zshrc
setopt aliases

# Run all arguments
cmd="${@:1}"
eval ${cmd}

