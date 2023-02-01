# mbp-manjaro Dockerfile
# Author: github.com/JPyke3 <Jacob Pyke, pyke.jacob1@gmail.com>

FROM manjarolinux/base

MAINTAINER jpyke3

# Update System
RUN [ "pacman", "-Syu", "manjaro-tools-iso-git",\ 
    "manjaro-tools-base-git",\
    "manjaro-tools-yaml-git",\
    "manjaro-tools-pkg-git",\
    "base-devel",\
    "git",\
    "lsb-release",\
    "fontconfig",\
    "--noconfirm" ]

# Import my Pacman GPG key