FROM alpine:3.2

ENV REFRESHED_AT 20151104

RUN apk --update add alpine-sdk xz poppler-dev pango-dev m4 libtool perl autoconf automake coreutils python-dev zlib-dev freetype-dev glib-dev cmake pango && \
    cd / && \
    git clone https://github.com/fontforge/libspiro.git && \
    cd libspiro && \
    autoreconf -i && \
    automake --foreign -Wall && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cd / && \
    git clone https://github.com/fontforge/libuninameslist.git && \
    cd libuninameslist && \
    autoreconf -i && \
    automake --foreign && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    cd / && \
    git clone https://github.com/BWITS/fontforge.git && \
    cd fontforge && \
    ./bootstrap --force && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-iconv && \
    make && \
    make install && \
    apk del alpine-sdk xz poppler-dev pango-dev m4 libtool perl autoconf automake coreutils python-dev zlib-dev freetype-dev glib-dev cmake && \
    apk add libpng python freetype glib libintl libxml2 libltdl cairo && \
    rm /var/cache/apk/* && \
    rm -rf /fontforge /libspiro /libuninameslist

CMD ["/usr/local/bin/fontforge"]
