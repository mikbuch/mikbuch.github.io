#!/usr/bin/env python
'''
Sound settings for amixer.

If argument is specified then set the volume to this value (in percents).
Else mute/unmute

Example use:

    python sound.py
    pythin sound.py 50

NOTICE:
    There is a way to just toggle sound on and off in amixer:
        amixer set Master toggle
    BUT: I am not using it here. Why? I need an "[on]" and "[off]" feedback.

development:
    show current volume state (in percents) at command call
'''

import argparse
import subprocess as sp

parser = argparse.ArgumentParser()
parser.add_argument("volume", nargs='?')
args = parser.parse_args()

cmd = 'amixer |grep Playback'
process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
output = process.communicate()[0]

if '[on]' in output:
    is_muted = False
else:
    is_muted = True


if args.volume is None:
    # if amixer sound muted, unmute it
    if is_muted:
        cmd = 'amixer set Master unmute'
        process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
        print('unmuted')

    # if amixer sound unmuted, mute it
    else:
        cmd = 'amixer set Master mute'
        process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
        print('muted')

else:
    vol = args.volume + '%'
    cmd = 'amixer set Master ' + vol
    process = sp.Popen(cmd, stdout=sp.PIPE, shell=True)
    print(vol)
    if is_muted:
        print('muted')
    else:
        print('unmuted')
