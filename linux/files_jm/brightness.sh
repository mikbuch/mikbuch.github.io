#!/bin/bash

args=("$@")

sudo tee /sys/class/backlight/intel_backlight/brightness <<< ${args[0]}
