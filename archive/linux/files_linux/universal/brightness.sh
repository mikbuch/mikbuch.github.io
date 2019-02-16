#!/bin/bash

# name: brightness.sh
# type: script
# description: interface for brightness regulation

args=("$@")

xbacklight -set ${args[0]}

# In case xbacklight won't work try this (requires root access):
# sudo tee /sys/class/backlight/intel_backlight/brightness <<< ${args[0]}
