#------------------------------------------------------------
# Copyright (c) 2020 Thomas Kais
#
# This file is subject to the terms and conditions defined in
# file 'COPYING', which is part of this source code package.
#------------------------------------------------------------

# Prune everything: https://docs.docker.com/config/pruning/#prune-images
# https://www.balena.io/docs/reference/base-images/base-images-ref/
# https://hub.docker.com/r/balenalib/raspberry-pi2-debian/
FROM balenalib/raspberry-pi2-debian:bullseye-build

# install frameworks and build tools
RUN install_packages \
      ccache \
      qt5-qmake \
      qttools5-dev \
      qttools5-dev-tools \
      pigpio

# copy repository to container
WORKDIR /build
COPY . .

# qmake/gcc version / generate project / build FotoBox / execution rights / compress artifact
# copy to host (mounted directory '--volume')