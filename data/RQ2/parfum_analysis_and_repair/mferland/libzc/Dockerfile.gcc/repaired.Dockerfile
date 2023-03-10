# libzc gcc:latest build environment

FROM gcc:latest
MAINTAINER Marc Ferland <marc.ferland@gmail.com>

RUN apt update \
    && apt upgrade -y \
    && apt install --no-install-recommends -y make automake libtool autoconf zlib1g-dev pkg-config check gcc \
    && apt clean && rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell /bin/bash dev

USER dev
WORKDIR /home/dev

CMD cd /home/dev/libzc \
    && rm -rf ./build-gcc \
    && mkdir build-gcc \
    && ./autogen.sh \
    && (([ -f Makefile ] && make distclean) || true) \
    && cd build-gcc \
    && ../configure CC="gcc" CFLAGS="-g -O2 -fno-sanitize-recover=undefined,address"\
    && make -j4 check
