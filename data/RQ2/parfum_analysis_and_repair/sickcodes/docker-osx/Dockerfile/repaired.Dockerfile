#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   /
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|
#
# Title:            Docker-OSX (Mac on Docker)
# Author:           Sick.Codes https://twitter.com/sickcodes
# Version:          6.0
# License:          GPLv3+
# Repository:       https://github.com/sickcodes/Docker-OSX
# Website:          https://sick.codes
#
# All credits for OSX-KVM and the rest at @Kholia's repo: https://github.com/kholia/osx-kvm
# OpenCore support go to https://github.com/Leoyzen/KVM-Opencore
# and https://github.com/thenickdude/KVM-Opencore/
#
# This Dockerfile automates the installation of Docker-OSX
# It will build a 200GB container. You can change the size using build arguments.
# This Dockerfile builds on top of the work done by Dhiru Kholia, and many others.
#
# Build:
#
#       docker build -t docker-osx .
#       docker build -t docker-osx --build-arg VERSION=10.15.5 --build-arg SIZE=200G .
#
# Basic Run:
#
#       docker run --device /dev/kvm --device /dev/snd -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" sickcodes/docker-osx:latest
#
# Run with SSH:
#
#       docker run --device /dev/kvm --device /dev/snd -e RAM=6 -p 50922:10022 -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" sickcodes/docker-osx:latest
#       # ssh fullname@localhost -p 50922
#
# Optargs:
#
#       -v $PWD/disk.img:/image
#       -e SIZE=200G
#       -e VERSION=10.15.6
#       -e RAM=5
#       -e SMP=4
#       -e CORES=4
#       -e EXTRA=
#       -e INTERNAL_SSH_PORT=10022
#       -e MAC_ADDRESS=
#
# Extra QEMU args:
#
#       docker run ... -e EXTRA="-usb -device usb-host,hostbus=1,hostaddr=8" ...
#       # you will also need to pass the device to the container

FROM archlinux:base-devel
LABEL maintainer='https://twitter.com/sickcodes <https://sick.codes>'

SHELL ["/bin/bash", "-c"]

# change disk size here or add during build, e.g. --build-arg VERSION=10.14.5 --build-arg SIZE=50G
ARG SIZE=200G

# OPTIONAL: Arch Linux server mirrors for super fast builds
# set RANKMIRRORS to any value other that nothing, e.g. -e RANKMIRRORS=true