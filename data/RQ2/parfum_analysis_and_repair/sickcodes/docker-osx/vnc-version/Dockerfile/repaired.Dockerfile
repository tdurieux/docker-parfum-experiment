#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   / 
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |  
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|  VNC EDITION
# 
# Title:            Mac on Docker (Docker-OSX) [VNC EDITION]
# Author:           Sick.Codes https://sick.codes/        
# Version:          3.1
# License:          GPLv3+
# 
# All credits for OSX-KVM and the rest at Kholia's repo: https://github.com/kholia/osx-kvm
# OpenCore support go to https://github.com/Leoyzen/KVM-Opencore 
# and https://github.com/thenickdude/KVM-Opencore/
# 
# This Dockerfile automates the installation of Docker-OSX
# It will build a 32GB Mojave Disk, you can change the size using build arguments.
# This file builds on top of the work done by Dhiru Kholia and many others.
#       
#
# Build:
#
#       # write down the password at the end
#       docker build -t docker-osx-vnc .
# 
# Run:
#       
#       docker run --device /dev/kvm --device /dev/snd -p 8888:5999 -p 50922:10022 -d --privileged docker-osx-vnc:latest
#
#
# Optional:
# 
#       -v $PWD/disk.img:/image
# 
# Connect locally (safe):
#
#       VNC Host:     localhost:8888
#
#
# Connect remotely (safe):
#
#
#       # Open a terminal and make an SSH tunnel on port 8888 to your server
#       ssh -N root@111.222.33.44 -L  8888:127.0.0.1:8888
#       
#       # now you can connect like a local
#       VNC Host:     localhost:8888
#
#
# Connect remotely (unsafe):
#
#       VNC Host:     remotehost:8888
#
#
# Security:
#
#       - Think what would happen if someone was in your App Store.
#       - Keep port 8888 closed to external internet traffic, allow local IP's only.
#       - All traffic is insecurely transmitted in plain text, try to use an SSH tunnel.
#       - Everything you write can be sniffed along the way.
#       - VNC Password is only 8 characters.
#
# Show VNC password again:
#
#       docker ps
#       # copy container ID and then 
#       docker exec abc123fgh456 tail vncpasswd_file
#
# VNC Version
# Let's piggyback the other image:

ARG BASE_IMAGE=sickcodes/docker-osx:latest
FROM ${BASE_IMAGE}

MAINTAINER 'https://twitter.com/sickcodes' <https://sick.codes>

USER root

# OPTIONAL: Arch Linux server mirrors for super fast builds
# set RANKMIRRORS to any value other that nothing, e.g. -e RANKMIRRORS=true