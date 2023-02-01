#default args
ARG OS_VERSION=latest
ARG INCLUDE_UHD=false
ARG INCLUDE_LIMESDR=false
ARG INCLUDE_CMNALIB_DEPS_FOR_SUBPROJECT=false
ARG INCLUDE_CMNALIB_GIT=false
ARG INCLUDE_CMNALIB_PKG=false
ARG INCLUDE_CMNALIB=true
ARG INCLUDE_SRSLTE_PATCHED_DEPS_FOR_SUBPROJECT=false
ARG INCLUDE_SRSLTE_PATCHED_GIT=false
ARG INCLUDE_SRSLTE_PATCHED_PKG=false
ARG INCLUDE_SRSLTE_PATCHED=true
ARG INCLUDE_SRSLTE=false

FROM archlinux:$OS_VERSION as archlinux_base

# Provide command add-apt-repository and apt-utils
RUN pacman -Suy --noconfirm

# General dependencies for development
RUN pacman -Sy base-devel cmake git --noconfirm

# Additional dependencies and configure for AUR/YAY
RUN pacman -Sy go sudo --noconfirm

WORKDIR /packages
RUN useradd -d /packages packer
RUN echo "packer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown -R packer /packages

USER packer
RUN git clone https://aur.archlinux.org/yay.git
WORKDIR /packages/yay
RUN makepkg -si --noconfirm
USER root

# FALCON dependencies
WORKDIR /
RUN pacman -Sy boost qt5-charts --noconfirm

# UHD (This is installed to satisfy condition RF_FOUND for srsLTE, any other supported RF frontend drivers should be good as well)