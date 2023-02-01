FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends \
        ant \
        autoconf \
        automake \
        build-essential \
        cmake \
        doxygen \
        gettext \
        git \
        libcairo-dev \
        libglib2.0-dev \
        libgdk-pixbuf2.0-dev \
        libjpeg-turbo8-dev \
        libopenjp2-7-dev \
        libsqlite3-dev \
        libtiff-dev \
        libtool \
        libturbojpeg0-dev \     
        libxml2-dev \
        pkg-config \
        mingw-w64 \   
        nano \
        nasm \     
        wget \   
        zip && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/GeertLitjens/openslide-winbuild
WORKDIR /root/openslide-winbuild
RUN mkdir override; cd override; \
    git clone https://github.com/GeertLitjens/openslide; \
    cd openslide; \
    git checkout feature/settable_cache_size; \
    autoreconf -i; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    make src/openslide-tables.c
ENTRYPOINT [ "/bin/bash", "/root/openslide-winbuild/build.sh", "-m64", "-p3.4.1-custom", "bdist"]