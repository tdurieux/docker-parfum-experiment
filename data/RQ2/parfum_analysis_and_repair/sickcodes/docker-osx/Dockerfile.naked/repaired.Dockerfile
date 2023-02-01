#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   / 
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |  
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|  :NAKED
# 
# Title:            Docker-OSX (Mac on Docker)
# Author:           Sick.Codes https://twitter.com/sickcodes
# Version:          6.0
# License:          GPLv3+
# Repository:       https://github.com/sickcodes/Docker-OSX
# Website:          https://sick.codes
# 
# This image won't run unless you supply a disk image using:
#       -v ${PWD}/mac_hdd_ng.img:/image
# 
# Take screenshots in the Arch container and display in terminal: scrotcat
#
# Build:
# 
#       docker build -t docker-osx:naked -f Dockerfile.naked .
# 
# Run headless:
# 
#       docker run -it --device /dev/kvm -p 50922:10022 -v ${PWD}/mac_hdd_ng.img:/image docker-osx:naked
# 
# Run with display:
# 
#       docker run -it --device /dev/kvm -p 50922:10022 -v ${PWD}/mac_hdd_ng.img:/image -e "DISPLAY=${DISPLAY:-:0.0}" -v /tmp/.X11-unix:/tmp/.X11-unix docker-osx:naked
# 

FROM sickcodes/docker-osx:latest

MAINTAINER 'https://twitter.com/sickcodes' <https://sick.codes>

USER root

WORKDIR /root

RUN rm -f /home/arch/OSX-KVM/mac_hdd_ng.img

# OPTIONAL: Arch Linux server mirrors for super fast builds
# set RANKMIRRORS to any value other that nothing, e.g. -e RANKMIRRORS=true