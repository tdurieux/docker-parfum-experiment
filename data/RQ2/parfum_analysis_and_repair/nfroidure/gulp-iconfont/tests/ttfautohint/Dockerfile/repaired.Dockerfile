FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget build-essential pkg-config qt4-qmake libqt4-dev \
    && mkdir -p /ttfautohint && cd /ttfautohint && rm -rf /var/lib/apt/lists/*;

ENV FT_VERSION=2.6.3
ENV HB_VERSION=1.2.7
ENV TA_VERSION=1.5

RUN wget https://download.savannah.gnu.org/releases/freetype/freetype-"$FT_VERSION".tar.bz2 \
    && tar xjf freetype-"$FT_VERSION".tar.bz2 \
    && ( cd freetype-"$FT_VERSION" && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-harfbuzz && make install && make distclean) \
    && wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-"$HB_VERSION".tar.bz2 \
    && tar xjf harfbuzz-"$HB_VERSION".tar.bz2 \
    && ( cd harfbuzz-"$HB_VERSION" && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) \
    && ( cd freetype-"$FT_VERSION" && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) \
    && wget https://downloads.sourceforge.net/project/freetype/ttfautohint/"$TA_VERSION"/ttfautohint-"$TA_VERSION".tar.gz \
    && tar xzf ttfautohint-"$TA_VERSION".tar.gz \
    && ( cd ttfautohint-"$TA_VERSION" && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install) && rm freetype-"$FT_VERSION".tar.bz2

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

ENTRYPOINT ["/usr/local/bin/ttfautohint"]
CMD ["/dev/stdin", "/dev/stdout"]
