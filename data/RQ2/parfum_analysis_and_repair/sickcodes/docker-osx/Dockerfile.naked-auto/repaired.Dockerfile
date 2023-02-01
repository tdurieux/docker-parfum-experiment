#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   / 
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |  
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|  :NAKED-AUTO
# 
# Title:            Docker-OSX (Mac on Docker)
# Author:           Sick.Codes https://twitter.com/sickcodes
# Version:          6.0
# License:          GPLv3+
# Repository:       https://github.com/sickcodes/Docker-OSX
# Website:          https://sick.codes
# 
# This Dockerfile needs you to supply a pre-installed installation of Docker-OSX!
# 
# Visit https://github.com/sickcodes/Docker-OSX for info

FROM sickcodes/docker-osx:latest

MAINTAINER 'https://twitter.com/sickcodes' <https://sick.codes>

USER root

WORKDIR /root

RUN rm -f /home/arch/OSX-KVM/mac_hdd_ng.img

# For taking screenshots of the Xfvb screen, useful during development.
ARG SCROT

# OPTIONAL: Arch Linux server mirrors for super fast builds
# set RANKMIRRORS to any value other that nothing, e.g. -e RANKMIRRORS=true