#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# autojump
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

alias ls='ls --color=auto'
PS1='[\W]\$ '

# fzf key bindings
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# required for GPG to be able to prompt for a passphrase
export GPG_TTY=$(tty)

export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts:$HOME/.cargo/bin"

# Created by `userpath` on 2023-03-31 14:53:48
export PATH="$PATH:/home/slarse/.repobee/bin"
