# Build Arch Linux Package in Docker
#
# Needs docker 17.05!
# https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
#
# Build with "./build.sh docker_arch [‹build-opts›…]"
#

ARG DISTRO=archlinux
ARG CODENAME=20200205
#ARG CODENAME=latest