# x11docker/umbrewm
# 
# Run umberwm desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: 
#   - Run desktop:
#       x11docker --desktop x11docker/umberwm
#   - Run single application:
#       x11docker x11docker/umberwm thunar
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host folder with                      --share DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# ALSA sound support with option               --alsa
# Pulseaudio sound support with option         --pulseaudio
# Language setting with                        --lang [=$LANG]
# Printing over CUPS with                      --printer
# Webcam support with                          --webcam
#
# Look at x11docker --help for further options.