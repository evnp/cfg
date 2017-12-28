source ~/.aliases

export PATH=$PATH:$HOME/bin # Add ~/bin to PATH for scripting
export PATH=$PATH:/opt/node/bin # Add Node to PATH
export PATH=$PATH:/usr/local/mysql/bin # Add MySQL to PATH

# Fix vim colors in Tmux
export TERM="xterm-256color"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

# Prompt
export PS1="\A\e[39m\[\033[32m\]\$(parse_git_branch)\[\033[00m\] \W \[\033[1;34m\]●\[\033[0m\] "
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

# History Management
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it
# Save and reload the history after each command finishes to share history between terminals
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Add to ~/.inputrc for history-searching up/down arrows
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# set show-all-if-ambiguous on
# set completion-ignore-case on

# Shelytics
# export SHELYTICS_LOCATION=~/Dropbox/Projects/shelytics
# export SHELYTICS_DATABASE=~/shelytics/shelytics.db
# export SHELYTICS_MP_TOKEN=bdb558ed12c58ba003ed7854792fb1e1
# source $SHELYTICS_LOCATION/shelytics.bash

alias gvim='mvim'
alias la='ls -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pj='cd ~/Dropbox/Projects'
alias env='echo "${VIRTUAL_ENV##*/}"'
alias permissions="stat -c '%a'"

# Python debugging
function debug {
    line=`sed "$2q;d" $1`
    if [[ $line != *"import pdb"* ]]; then
        sed -i -E "$2s/^(\s+)(.*)$/\1import pdb; pdb.set_trace();\r\n\1\2/" $1;
    fi
}
function undebug {
    line=`sed "$2q;d" $1`
    if [[ $line == *"import pdb"* ]]; then
        sed -i "$2d" $1;
    fi
}

# on_cwd_change() {
#   if [ "$PWD" != "$MYOLDPWD" ]; then
#     MYOLDPWD="$PWD";
#     activate_virtualenv
#   fi
# }
#
# activate_virtualenv() {
#     if [ -e .venv ]
#     then
#         VENV=`cat .venv`;
#         workon "$VENV";
#         echo "workon $VENV";
#         ENVPWD="${PWD##*/}";
#     elif [ -d "$ENVPWD" ]
#     then
#         echo "deactivate $VENV";
#         deactivate;
#     fi
# }
#
# export PROMPT_COMMAND=on_cwd_change

# auto_activate_virtualenv() {
#   if [ -f ./bin/activate ]
#   then
#     . ./bin/activate
#     hash -r
#   fi
# }
# export PROMPT_COMMAND="auto_activate_virtualenv"

# Source alias
alias src="source ~/.bash_profile"
alias bash_profile="gvim ~/.bash_profile"

alias svndifflist='svn diff --diff-cmd "diff" -x "-q" . | grep Index | cut -d " " -f 2'
alias svndiffsplit='svn diff --diff-cmd "diff" -x "-y --suppress-common-lines"'

# how2 (cli stackoverflow) aliases
alias hjs='how2 -l javascript'
alias hpy='how2 -l python'
alias hgit='how2 -l git'

# View diff in GVim (pretty colors)
function gvdiff { svn diff $1 | gvim -R -; }

# View log in GVim
function gvlog { svn log -l $1 | gvim -R -; }

# Find files by name and open them in Gvim
function gvfind { find . -name "$1" | xargs mvim; }

# Find files by content and open them in Gvim
function vack { ack "$1" --files-with-matches | xargs vim; }
function gvack { ack "$1" --files-with-matches | xargs gvim; }

function gvold {
  if ! [ $2 ]; then
    REVISION='HEAD'
  else
    REVISION=$2
  fi
  svn cat -r $REVISION $1 | gvim -R -;
}

alias listfeatures="ls ~/patches"
function savefeature {
  if [ -f ~/patches/$1.patch ]; then
    DATE=`date +%H.%M.%S-%d.%m.%y`;
    cp ~/patches/$1.patch ~/patches/bkp/;
    mv ~/patches/bkp/$1.patch ~/patches/bkp/$1-$DATE.patch;
  fi
  svn diff > ~/patches/$1.patch;
}
function loadfeature { patch -p0 < ~/patches/$1.patch; }
function viewfeature { gvim ~/patches/$1.patch; }

alias svnstash="savefeature stash && svn revert --recursive ."
alias svnunstash="loadfeature stash"

function b64 { echo "$1" | base64 --decode; }

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Make sure ssh agent is always running
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
    ssh-agent > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}
if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
fi
if [ -n "$SSH_AGENT_PID" ]; then
    ps ${SSH_AGENT_PID} > /dev/null
    if [ $? -ne 0 ]; then
        start_agent
    fi
else
    start_agent
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/evnp/google-cloud-sdk/path.bash.inc' ]; then source '/home/evnp/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/evnp/google-cloud-sdk/completion.bash.inc' ]; then source '/home/evnp/google-cloud-sdk/completion.bash.inc'; fi

function replace {
  echo $1
  echo $2
  ack -f | xargs sed -i $1
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
