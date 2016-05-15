#
# ~/.bash_profile
#

# I use .bash_profile, not .bashrc, because the latter won't be initialized
# at startup
#
#

# beep settings - turn of pcspeaker so that it won't beep anymore
if lsmod | grep "pcspkr" &> /dev/null ; then
    echo "pcspkr is loaded, removing"
    rmmod pcspkr
else
    echo "pcspkr isn't loaded"
fi

# font settings
setfont /usr/share/kbd/consolefonts/ter-u18b.psf.gz

# ls alias - pretty list format
alias l='ls --color=auto -l'

# directories (cd) aliases
alias t='cd /tmp'
