#!/bin/sh

stow tmux
mkdir -p ~/.config && stow --target ~/.config nvim
