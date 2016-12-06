#!/bin/bash

# This script has two arguments.
# The settings can be applied either locally or globally.
# Local settings are paced mostly in ~/ home directory.
# Global settings have place in /etc directory.

# All files are backed up before overwriting with cp command.


############################################
#
# User has to specify range of the settings
#
# This conditions doesnt look spectacular.
# Bash is a very demanding language in terms of conditions.

argument_specified=true
if [[ $# -eq 0 ]]; then
    argument_specified=false
fi

if [[ ! ("$1" == "local" || "$1" == "global") ]]; then
    argument_specified=false
fi

if [[ $argument_specified = false ]]; then
    echo ""
    echo "You MUST specify range of the settings."
    echo "Two options are available:"
    echo " * local settings, e.g. bash arch_conf.sh local"
    echo " * global settings, e.g. bash arch_conf.sh global"
    echo "     - global settings needs root privileges"
    echo ""
    exit 0
fi


############################################
#
# Create directory containing confs
#
if [ ! -d arch_config ]; then
    mkdir arch_config
else
    echo "*** WARNING ***"
    echo "Directory arch_config already exists, skipping."
fi
cd arch_config


domain="https://github.com/mikbuch/mikbuch.github.io/blob/master/linux/files_linux/arch_config/"

files="bashrc tmux.conf vimrc xinitrc Xresources"



backup_code=$(date "+%Y%m%d%H%M%S")
echo $backup_code
exit 0

# Resolve files from the `files` list.
for file in $files
do
    ##############################################
    #
    #               BASHRC
    #
    if [[ $file == "bashrc" ]]; then
        curl -O $domain$file
        curl -O $domain"bash_profile"

        # Backup ~/.bash_profile if exists.
        if [[ -f ~/.bash_profile ]]; then
            cp ~/.bash_profile ./bash_profile_$backup_code.bak
        fi
        echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" > ~/.bash_profile

        # Backup ~/.bashrc if exists.
        if [[ -f ~/.bashrc ]]; then
            cp ~/.bashrc ./bashrc_$backup_code.bak
        fi

        if [[ "$1" == "local" ]]; then

            cp bashrc ~/.bashrc 
            source ~/.bashrc
        else
            # Backup /etc/bash.bashrc if exists.
            if [[ -f /etc/bash.bashrc ]]; then
                cp /etc/bash.bashrc ./bash.bashrc_$backup_code.bak
            fi

            cp bashrc /etc/bash.bashrc 
            echo "source /etc/bash.bashrc" > ~/.bashrc
            source /etc/bash.bashrc
        fi
    
    ##############################################
    #
    #               TMUX.CONF
    #
    elif [[ $file == "tmux.conf" ]]; then
        if [[ "$1" == "local" ]]; then
            # Backup ~/.tmux.conf if exists.
            if [[ -f ~/.tmux.conf ]]; then
                cp ~/.tmux.conf ./tmux_conf_$backup_code.bak
            fi

            cp tmux_conf ~/.tmux.conf 
            tmux source-file ~/.tmux.conf
        else
            # Backup /etc/tmux.conf if exists.
            if [[ -f /etc/tmux.conf ]]; then
                cp /etc/tmux.conf ./tmux_conf_$backup_code.bak
            fi

            cp tmux_conf /etc/tmux.conf 
            tmux source-file /etc/tmux.conf
        fi
    fi

    ##############################################
    #
    #                 VIMRC
    #
    elif [[ $file == "vimrc" ]]; then
        if [[ "$1" == "local" ]]; then
            # Backup ~/.vimrc if exists.
            if [[ -f ~/.vimrc ]]; then
                cp ~/.vimrc ./vimrc_$backup_code.bak
            fi

            cp vimrc ~/.vimrc 
        else
            # Backup /etc/vimrc exists.
            if [[ -f /etc/vimrc ]]; then
                cp /etc/vimrc ./vimrc_$backup_code.bak
            fi

            cp vimrc /etc/vimrc 
        fi
    fi

    ##############################################
    #
    #                 XINITRC
    #

    ##############################################
    #
    #                XRESOURCES
    #
done
