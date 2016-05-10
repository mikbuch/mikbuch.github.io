#
# ~/.bash_profile
#

# I use .bash_profile, not .bashrc, because the latter won't be initialized
# at startup
#
#

# inter
# [[ $- != *i* ]] && return

# beep settings - turn of pcspeaker so that it won't beep anymore
rmmod pcspkr

# font settings
setfont /usr/share/kbd/consolefonts/ter-u18b.psf.gz

# ls alias - pretty list format
alias l='ls --color=auto -l'

# directories (cd) aliases
alias t='cd /tmp'
