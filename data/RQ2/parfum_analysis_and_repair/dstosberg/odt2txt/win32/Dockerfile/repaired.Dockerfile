# docker build -t odt2txt-win32 .
# docker run --rm -v /tmp:/dist odt2txt-win32
# docker rmi odt2txt-win32

FROM debian:jessie

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y wget git mingw32 zip && rm -rf /var/lib/apt/lists/*;

USER nobody
RUN cd /tmp \
    && wget ftp://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz \
    && tar xzf libiconv-1.14.tar.gz \
    && cd libiconv-1.14 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=i686-w64-mingw32 --prefix=/usr/i686-w64-mingw32/ \
    && make && rm libiconv-1.14.tar.gz

USER root
RUN cd /tmp/libiconv-1.14 \
    && make install

USER nobody
RUN cd /tmp \
    && wget https://ftp.gnu.org/old-gnu/regex/regex-0.12.tar.gz \
    && tar xzf regex-0.12.tar.gz \
    && cd regex-0.12 \
    && i686-w64-mingw32-gcc -DSTDC_HEADERS=1 -c regex.c && rm regex-0.12.tar.gz

RUN cd /tmp \
    && wget https://zlib.net/zlib-1.2.8.tar.gz \
    && tar xzf zlib-1.2.8.tar.gz \
    && cd zlib-1.2.8 \
    && make -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- && rm zlib-1.2.8.tar.gz

RUN cd /tmp \
    && wget https://www.nih.at/libzip/libzip-1.0.1.tar.gz \
    && tar xzf libzip-1.0.1.tar.gz \
    && cd libzip-1.0.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=i686-w64-mingw32 --prefix=/usr/i686-w64-mingw32/ --with-zlib=/tmp/zlib-1.2.8/ \
    && make && rm libzip-1.0.1.tar.gz

RUN cd /tmp \
    && git clone https://github.com/dstosberg/odt2txt \
    && cd odt2txt \
    && make CC=i686-w64-mingw32-gcc MINGW32=1 REGEX_DIR=/tmp/regex-0.12 ZLIB_DIR=/tmp/zlib-1.2.8 STATIC=1 ICONV_DIR=/tmp/libiconv-1.14 LIBZIP_DIR=/tmp/libzip-1.0.1/

RUN cd /tmp/odt2txt \
    && export VERSION=$(git describe --tags) \
    && export DIST_DIR=/tmp/odt2txt-$VERSION \
    && mkdir $DIST_DIR \
    && cd $DIST_DIR \
    && cp /tmp/odt2txt/odt2txt.exe . \
    && cp /tmp/odt2txt/README.md . \
    && cp /tmp/odt2txt/GPL-2 . \
    && cd .. \
    && zip -r odt2txt-${VERSION}.zip odt2txt-$VERSION \
    && echo "#!/bin/bash" > /tmp/copy-dist.sh \
    && echo "cp -v /tmp/odt2txt-${VERSION}.zip /dist" >> /tmp/copy-dist.sh

CMD sh /tmp/copy-dist.sh

