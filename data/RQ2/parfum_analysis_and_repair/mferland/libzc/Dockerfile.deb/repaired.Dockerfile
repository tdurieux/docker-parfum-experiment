# libzc debian build environment

FROM debian:unstable-slim
MAINTAINER Marc Ferland <marc.ferland@gmail.com>

RUN apt update \
    && apt upgrade -y \
    && apt install --no-install-recommends -y make automake libtool autoconf zlib1g-dev pkg-config git devscripts check gcc gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell /bin/bash dev

USER dev
WORKDIR /home/dev

COPY devscripts /home/dev/.devscripts

CMD cd /home/dev/libzc && ./builddeb
