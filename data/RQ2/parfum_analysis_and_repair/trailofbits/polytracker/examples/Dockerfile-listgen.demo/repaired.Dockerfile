FROM trailofbits/polytracker
MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>

WORKDIR /polytracker/the_klondike

ENV CC=clang
ENV CXX=clang++

RUN apt update

#Update pkg-config/util-linux (needed for FontConfig)
RUN apt update
RUN apt install --no-install-recommends pkg-config uuid-dev gperf libtool \
	gettext autopoint autoconf -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends python3-dev && rm -rf /var/lib/apt/lists/*;

#Fontconfig requires some stuff?
RUN apt install --no-install-recommends pkg-config libasound2-dev libssl-dev cmake libfreetype6-dev libexpat1-dev libxcb-composite0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends libxml2-dev -y && rm -rf /var/lib/apt/lists/*;

#=================================
WORKDIR /polytracker/the_klondike

#FreeType http://www.linuxfromscratch.org/blfs/view/svn/general/freetype2.html
RUN wget https://downloads.sourceforge.net/freetype/freetype-2.10.1.tar.xz
RUN tar -xvf freetype-2.10.1.tar.xz && rm freetype-2.10.1.tar.xz

WORKDIR freetype-2.10.1

#Some linux from scratch magic
RUN sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
RUN sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-freetype-config
RUN make -j5 install

#=================================
WORKDIR /polytracker/the_klondike

#zlib
RUN wget https://www.zlib.net/zlib-1.2.11.tar.gz
RUN tar -xzvf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz
WORKDIR zlib-1.2.11
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j$(nproc) test && make -j$(nproc) install

#=================================
WORKDIR /polytracker/the_klondike

#Libxml2

RUN wget https://xmlsoft.org/sources/libxml2-2.9.10.tar.gz
RUN tar -xvf libxml2-2.9.10.tar.gz && rm libxml2-2.9.10.tar.gz
WORKDIR libxml2-2.9.10
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --with-python=/usr/bin/python3
RUN make -j10
RUN make install


#=================================
WORKDIR /polytracker/the_klondike

#Fontconfig (depends on FreeType), note that the linux from scratch version is broken
#The gitlab version is up to date, and has a PR merged from a year ago with the bug fix
#https://gitlab.freedesktop.org/fontconfig/fontconfig/merge_requests/2/diffs?commit_id=8208f99fa1676c42bfd8d74de3e9dac5366c150c

RUN git clone https://gitlab.freedesktop.org/fontconfig/fontconfig.git

WORKDIR fontconfig
RUN ./autogen.sh --sysconfdir=/etc --prefix=/usr --enable-libxml2 --mandir=/usr/share/man
RUN make -j10 install

#=================================
WORKDIR /polytracker/the_klondike

#Poppler 0.84.0

#RUN wget https://poppler.freedesktop.org/poppler-0.84.0.tar.xz
#RUN tar -xvf poppler-0.84.0.tar.xz
#WORKDIR poppler-0.84.0
#RUN cmake -DBUILD_SHARED_LIBS=OFF -DENABLE_LIBOPENJPEG=unmaintained -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang ..
#RUN mkdir build
#WORKDIR build
#RUN cmake -DBUILD_SHARED_LIBS=OFF -DBUILD_GTK_TESTS=OFF -DBUILD_QT4_TESTS=OFF -DBUILD_QT5_TESTS=OFF -DBUILD_CPP_TESTS=OFF -DENABLE_SPLASH=OFF -DENABLE_CPP=OFF -DENABLE_GLIB=OFF -DENABLE_GTK_DOC=OFF -DENABLE_QT4=OFF -DENABLE_QT5=OFF -DENABLE_LIBOPENJPEG=unmaintained -DENABLE_CMS=none -DENABLE_LIBCURL=OFF -DENABLE_ZLIB=OFF -DENABLE_DCTDECODER=unmaintained -DENABLE_ZLIB_UNCOMPRESS=OFF -DSPLASH_CMYK=OFF -DWITH_JPEG=OFF -DWITH_PNG=OFF -DWITH_TIFF=OFF -DWITH_NSS3=OFF -DWITH_Cairo=OFF -DWITH_FONTCONFIGURATION_FONTCONFIG=OFF -DCMAKE_EXE_LINKER_FLAGS="-pthread" ../

#RUN make -j5 install

#=================================
WORKDIR /polytracker/the_klondike

# Note, the /workdir directory is intended to be mounted at runtime
VOLUME ["/workdir"]
WORKDIR /workdir
