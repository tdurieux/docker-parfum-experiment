# Goals of this file:
# - Prevent untracked (gitignore'd) files from affecting the build
# - Cache as much as possible to allow quick iteration
#
# Hence the aria2 build should be cached since it rarely changes and takes about 5 times as long to
# build as the updater. To permit caching, the aria2 directory needs to be copied separately before
# the rest of updater2.
#
# git clean -dXff is used to delete all the files specified by .gitignore. This requires the data
# from .git since a checked-in file will not be ignored. For aria2 it is assumed that the data
# is stored in the updater2/.git/modules directory.

FROM debian:buster-slim
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    autopoint \
    curl \
    gettext \
    g++ \
    g++-mingw-w64-i686 \
    git \
    libtool \
    make \
    p7zip-full \
    pkg-config \
    python \
    xz-utils && rm -rf /var/lib/apt/lists/*;

# Something in Qt does not build with win32 thread flavor
RUN update-alternatives --set i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-posix && \
    update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix

# The Schannel dependencies are spelled with capital letters which causes them not to be found
RUN ln -s libsecur32.a /usr/i686-w64-mingw32/lib/libSecur32.a && \
    ln -s libcrypt32.a /usr/i686-w64-mingw32/lib/libCrypt32.a

############
# Build Qt #
############
WORKDIR /build-qt
ENV UPDATER_MODULES=qtbase,qtquickcontrols,qtquickcontrols2,qtsvg,qtgraphicaleffects
RUN curl -f -LO https://download.qt.io/archive/qt/5.14/5.14.2/single/qt-everywhere-src-5.14.2.tar.xz && \
    curl -f -L https://download.qt.io/archive/qt/5.14/5.14.2/single/md5sums.txt | md5sum --check --ignore-missing && \
    tar -xJf qt-everywhere-src-5.14.2.tar.xz && \
    cd qt-everywhere-src-5.14.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -release -static -prefix /qt -qt-zlib -qt-libjpeg -qt-libpng -qt-freetype -qt-pcre -qt-harfbuzz -opengl desktop -opensource -confirm-license -no-qml-debug -no-icu -xplatform win32-g++ -device-option CROSS_COMPILE=i686-w64-mingw32- -optimize-size --c++std=14 -nomake tests -nomake tools -nomake examples -schannel && \
    bash -c "make -j`nproc` module-{$UPDATER_MODULES} && make module-{$UPDATER_MODULES}-install_subtargets" && \
    rm -rf /build-qt && rm qt-everywhere-src-5.14.2.tar.xz

###############
# Build aria2 #
###############
COPY aria2 /updater2/aria2
COPY .git/modules/aria2 /updater2/.git/modules/aria2
WORKDIR /updater2/aria2
RUN git clean -dXff
RUN autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-libxml2 --without-libexpat --without-sqlite3 --enable-libaria2 --without-libz --without-libcares --enable-static=yes ARIA2_STATIC=yes --without-libssh2 --disable-websocket --disable-nls --host i686-w64-mingw32 && make -j`nproc`

#################
# Build updater #
#################
COPY . /updater2
RUN set -e; for D in . quazip fluid; do cd /updater2/$D && git clean -dXff; done
WORKDIR /build
RUN /qt/bin/qmake -config release QMAKE_LFLAGS+="-static" INCLUDEPATH+=/qt/include/QtZlib /updater2 && make -j`nproc`
WORKDIR /release-win
ARG release
RUN if [ -n "$release" ]; then cp /build/release/updater2.exe UnvanquishedUpdater.exe && 7z -tzip -mx=9 a UnvUpdaterWin.zip UnvanquishedUpdater.exe; fi
