FROM debian:10.9-slim
ARG MAKE_OPTS=-j12
ARG SDL_VERSION
ARG ISPACK_VERSION
ARG INNOEXTRACT_VERSION

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --no-install-recommends -y automake autotools-dev build-essential genisoimage mingw-w64 pkgconf \
            unzip wine32 && \
    ln -sf /usr/bin/genisoimage /usr/bin/mkisofs && rm -rf /var/lib/apt/lists/*;

COPY vendor/innoextract-${INNOEXTRACT_VERSION}-linux.tar.xz /tmp/
RUN cd /tmp && \
    tar xf innoextract-${INNOEXTRACT_VERSION}-linux.tar.xz && \
    cp innoextract-${INNOEXTRACT_VERSION}-linux/bin/amd64/innoextract /usr/local/bin && \
    rm -rf /tmp/innoextract-${INNOEXTRACT_VERSION}* && rm innoextract-${INNOEXTRACT_VERSION}-linux.tar.xz

ENV PATH="/usr/x86_64-w64-mingw32/bin:${PATH}"
COPY vendor/SDL2-${SDL_VERSION}.tar.gz /tmp/
RUN cd /tmp && \
    tar xzf SDL2-${SDL_VERSION}.tar.gz && \
    cd SDL2-${SDL_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=x86_64-w64-mingw32 --prefix=/usr/x86_64-w64-mingw32 && \
    make ${MAKE_OPTS} && \
    make install && \
    echo "/usr/x86_64-w64-mingw32/share/aclocal" > /usr/share/aclocal/dirlist && \
    rm -rf /tmp/SDL2-${SDL_VERSION}* && rm SDL2-${SDL_VERSION}.tar.gz

COPY vendor/ispack-${ISPACK_VERSION}-unicode.exe /tmp/
RUN mkdir /innosetup && \
    innoextract -d /innosetup /tmp/ispack-${ISPACK_VERSION}-unicode.exe && \
    rm -f /tmp/ispack-${ISPACK_VERSION}-unicode.exe

