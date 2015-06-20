#!/usr/bin/env python

import subprocess as sp
import shutil
from os import path

cmd = 'python /chartula/python/xfce/xfce_appearance_change.py'
process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
output = process.communicate()[0].rstrip()

# xfce4-terminal settings grey on black
if output == 'dark':
    shutil.copy(
        path.expanduser(
            '~/.config/xfce4/terminal/terminalrc.grey_on_black'
        ),
        path.expanduser(
            '/home/jesmasta/.config/xfce4/terminal/terminalrc'
        )
        )
    # tmux border settings (dark)
    cmd = 'tmux source-file ~/.tmux.conf.dark'
    process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)

# xfce4-terminal settings black on white
else:
    shutil.copy(
        path.expanduser(
            '~/.config/xfce4/terminal/terminalrc.xterm'
        ),
        path.expanduser(
            '/home/jesmasta/.config/xfce4/terminal/terminalrc'
        )
        )
    # tmux border settings (light)
    cmd = 'tmux source-file ~/.tmux.conf.light'
    process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
