# Copyright (C) 2019  Braiins Systems s.r.o.
#
# This file is part of Braiins Open-Source Initiative (BOSI).
#
# BOSI is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Please, keep in mind that we may also license BOSI or any part thereof
# under a proprietary license. For more information on the terms and conditions
# of such proprietary license or if you have any other questions, please
# contact us at opensource@braiins.com.

# docker build --build-arg LOC_UID=$(id -u) --build-arg LOC_GID=$(id -g) -t bos-builder docker/
# docker run --rm -v $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent -ti bos-builder

FROM debian:9.6 AS build-system

RUN apt-get update && apt-get install -y \
    build-essential \
    sudo \
    python3 \
    python3-pip \
    virtualenv \
    git \
    gawk \
    zlib1g-dev \
    libncurses5-dev \
    unzip \
    wget \
    python2.7 \
    libssl1.0-dev \
    texinfo \
    device-tree-compiler \
    python3-gdbm \
    curl \
    dosfstools \
    mtools

FROM build-system

ENV USER build

ARG LOC_UID
ARG LOC_GID
RUN addgroup --gid=$LOC_GID $USER && \
    adduser --system --uid=$LOC_UID --gid=$LOC_GID $USER

WORKDIR /home/$USER
USER $USER

COPY --chown=build:build ./requirements.txt .
RUN pip3 install -r requirements.txt

COPY --chown=build:build ./bashrc ./.bashrc
COPY --chown=build:build ./requirements.md5 .

ENV PATH="/home/$USER/.cargo/bin:${PATH}"
RUN bash -c "curl --proto '=https' --tlsv1.2 -sSf 'https://sh.rustup.rs' | sh /dev/stdin -y"

RUN rustup toolchain install 1.40.0 && \
    rustup component add rustfmt && \
    rustup target add arm-unknown-linux-musleabi --toolchain 1.40.0 && \
    rustup default 1.40.0
