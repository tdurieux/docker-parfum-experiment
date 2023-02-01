# https://github.com/CM2Walki/steamcmd - root version  2021/04/04

############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:10.9-slim

LABEL author="walentinlamonos@gmail.com"
LABEL maintainer="spootdev@gmail.com"
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive