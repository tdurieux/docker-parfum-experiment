#!/usr/bin/docker
#     ____             __             ____  ______  __
#    / __ \____  _____/ /_____  _____/ __ \/ ___/ |/ /
#   / / / / __ \/ ___/ //_/ _ \/ ___/ / / /\__ \|   / 
#  / /_/ / /_/ / /__/ ,< /  __/ /  / /_/ /___/ /   |  
# /_____/\____/\___/_/|_|\___/_/   \____//____/_/|_|  :AUTO
# 
# Title:            Docker-OSX (Mac on Docker)
# Author:           Sick.Codes https://twitter.com/sickcodes
# Version:          6.0
# License:          GPLv3+
# Repository:       https://github.com/sickcodes/Docker-OSX
# Website:          https://sick.codes
# 
# This Dockerfile is a pre-installed naked installation of Docker-OSX!
# 
#   Default username: user
#   Default password: alpine
# 
# Take screenshots in the Arch container and display in terminal: scrotcat
# readme: 
# timezone: UTC/GMT
# 
# Future versions will navigate the installation process, inside the Dockerfile.
# 
#
# Build:
#
#       docker build -t docker-osx:auto -f Dockerfile.auto .
# 
# Run:
# 
#       docker run -it --device /dev/kvm -p 50922:10022 -v ${PWD}/mac_hdd_ng_auto.img:/image     docker-osx-auto:latest
# 
# SSH:
#       From inside the container:
#           ssh -i ~/.ssh/id_docker_osx user@127.0.0.1 -p 10022
# 
#       From outside the container:
#           ssh localhost user@127.0.0.1 -p 50922
#           docker exec -it containerid ssh -i ~/.ssh/id_docker_osx user@127.0.0.1 -p 10022

FROM sickcodes/docker-osx:latest

MAINTAINER 'https://twitter.com/sickcodes' <https://sick.codes>

USER root

WORKDIR /root

# For taking screenshots of the Xfvb screen, useful during development.
ARG SCROT

# OPTIONAL: Arch Linux server mirrors for super fast builds
# set RANKMIRRORS to any value other that nothing, e.g. -e RANKMIRRORS=true