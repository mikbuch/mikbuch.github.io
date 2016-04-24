# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
alias l='ls -CF -l'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# xfce settings manager
alias xfapp='python /chartula/python/xfce/xfce_appearance_change.py'
alias tap='python /chartula/python/xfce/tap_to_click_xfce.py'

# programs, scripts and commands - aliases
alias acroread='acroread -openInNewWindow'
alias b='/home/jesmasta/git/mikbuch.github.io/linux/files_linux/brightness.sh'
alias c='python ~/.colours.py'
alias e='evince'
alias g='gpicview'
alias i='iceweasel '
alias ic='iceweasel &'
alias iceweasel='iceweasel -new-window'
alias iq='iceweasel -new-window --private'
alias m='mplayer -zoom -fs'
alias nonzero='python /home/jesmasta/git/pymri/pymri/utils/standalone/count_nonzero.py'
alias pm='bash /git/debian_jm/bashrc/pymri_install.sh'
alias s='python ~/.sound.py'
alias v='vim'
alias zotero='/home/jesmasta/soft/Zotero_linux-x86_64/zotero'

alias caret='/opt/caret/bin_linux64/caret5'
alias scilab='/opt/scilab-5.5.1/bin/scilab'
alias eclipse='/opt/eclipse/eclipse'

# directories, folders - aliases
alias d='cd /home/jesmasta/downloads'
alias dld='cd /home/jesmasta/downloads'
alias ds='cd /home/jesmasta/amu/neurosci/ds105/'
alias master='cd /amu/master'
alias neuro='cd /home/jesmasta/amu/neurosci/ds105/sub002/BOLD'
alias p='cd /git/pymri'
alias t='cd /tmp'
alias tmp='cd /tmp'
# alias wd='cd /home/jesmasta/git/pyseeg/pyseeg/openbci/scripts'
alias wd='cd /home/jesmasta/git/pymri/pymri/gui/'
# alias wd='cd /home/jesmasta/git/pymri/examples/'
alias www='cd /var/www'
alias x='cd /x/'
alias y='cd /home/jesmasta/git/pyseeg/pyseeg/openbci/scripts/'
alias z='cd /z/'

# fsl settings
source /etc/fsl/5.0/fsl.sh

# freesurfer settings
FREESURFER_HOME=/usr/local/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# afni settings (global system command)
PATH=$PATH:/home/jesmasta/soft/linux_openmp_64/

# caret settings (global system command)
PATH=$PATH:/opt/caret/bin_linux64/

# mricron settings (global system command)
PATH=$PATH:/home/jesmasta/soft/mricrone/mricron/

# disable flow control for that terminal completely (not just for vim). 
stty -ixon

export PYLEARN2_DATA_PATH=/home/jesmasta/downloads/pylearn2_data

# load tmux settings
tmux source-file ~/.tmux.conf