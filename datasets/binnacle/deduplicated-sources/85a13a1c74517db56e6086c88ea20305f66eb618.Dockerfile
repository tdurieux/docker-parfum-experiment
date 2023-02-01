FROM debian:stretch-slim
ARG cores=12
#Do not remove /var/lib/apt/lists due to later download
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates gnupg2 && \
    (wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - ) && \
    echo "deb [arch=amd64] http://deb.debian.org/debian stretch main\ndeb [arch=armhf] http://mirrordirector.raspbian.org/raspbian/ stretch main rpi" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends xz-utils bzip2 git make zip g++ python3-minimal

ENV prebuilt=/build/prebuilt toolchains=/build/toolchains
WORKDIR /build

# Toolchain from https://github.com/abhiTronix/raspberry-pi-cross-compilers
ENV gcc=8.3.0
RUN mkdir -p ${toolchains} && cd ${toolchains} && \
    (wget -q https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/GCC%20${gcc}/Raspberry%20Pi%201%2C%20Zero/cross-gcc-${gcc}-pi_0-1.tar.gz -O - | tar -xz) && \
    (find cross-pi-gcc* -name '*6.3.0*' -print0 | xargs -0 rm -Rf) && \
    mv cross-pi-gcc* armhf-linux

ENV boost=1.70.0
RUN bash -c "wget -q https://dl.bintray.com/boostorg/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh && \
    echo "using gcc : ${gcc} : ${toolchains}/armhf-linux/bin/arm-linux-gnueabihf-g++  ;" > tools/build/src/user-config.jam && \
    ./bjam toolset=gcc-${gcc} link=static threading=multi target-os=linux variant=release --layout=system \
      cflags="-march=armv6 -mfpu=vfp -mfloat-abi=hard -ffunction-sections -fdata-sections" \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-linux-armhf/lib install && \
    cd .. && rm -Rf boost_*

# Cross-root
ENV crossroot=${prebuilt}/root-linux-armhf
RUN mkdir -p ${crossroot} && cd ${crossroot} && \
    bash -c "apt download {libbsd0,libc6,libx11-6,libxau6,libxcb1,libxdmcp6,libxext6}:armhf \
               {libfontconfig1,libexpat1,libfreetype6,libx11,libxcursor,libxext,libxfixes,libxrandr,libxrender,zlib1g}-dev:armhf \
               x11proto-{core,fixes,randr,render,xext}-dev \
               {libasound2,libpulse}-dev:armhf \
               2>/dev/null" && \
    (for pkg in *.deb ; do dpkg -x ${pkg} . ; done) && \
    rm *.deb

ENV qt=4.8.7
RUN bash -c "wget -q http://download.qt.io/archive/qt/${qt%.*}/${qt}/qt-everywhere-opensource-src-${qt}.tar.gz -O - | tar -xz" && \
    cd qt-everywhere* && \
    (mkdir mkspecs/linux-g++-armhf && cd mkspecs/linux-g++-armhf && \
      cp ../linux-g++/qplatformdefs.h . && \
      echo "include(../linux-g++/qmake.conf)\n"\
        "QMAKE_CFLAGS = -march=armv6 -mfpu=vfp -mfloat-abi=hard\n"\
        "CONFIG += hide_symbols\n"\
        "CROSS_COMPILE=${toolchains}/armhf-linux/bin/arm-linux-gnueabihf-\n"\
        "CROSSROOT=${crossroot}\n"\
        "QMAKE_INCDIR_X11=\$\${CROSSROOT}/usr/include \$\${CROSSROOT}/usr/include/freetype2\n"\
        "QMAKE_LIBDIR_X11=\$\${CROSSROOT}/usr/lib/arm-linux-gnueabihf\n"\
        "QMAKE_LFLAGS=-Wl,-rpath-link,\$\${CROSSROOT}/lib/arm-linux-gnueabihf -Wl,-rpath-link,\$\${QMAKE_LIBDIR_X11}\n"\
      > qmake.conf && \
      grep CROSS_COMPILE ../win32-g++/qmake.conf >> qmake.conf ) && \
    ./configure -v -arch arm -xplatform linux-g++-armhf -prefix ${prebuilt}/qt-${qt}-linux-armhf \
      -release -opensource -static -fast -confirm-license \
      -no-accessibility -no-opengl -no-openvg -no-sql-sqlite -no-qt3support -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon -no-phonon-backend \
      -no-svg -no-webkit -no-javascript-jit -no-script -no-scripttools -no-declarative -no-declarative-debug \
      -qt-libpng -fontconfig -xrender -xrandr -xfixes -xshape -no-sm -no-nas-sound -no-neon \
      -no-gif -no-libtiff -no-libmng -no-libjpeg -no-openssl -no-nis -no-cups -no-pch -no-qdbus -no-dbus -no-gtkstyle -no-glib \
      -nomake demos -nomake examples -nomake docs -nomake translations -nomake assistant -nomake qdoc3 -nomake qtracereplay -nomake linguist \
      -nomake qt3to4 -nomake qcollectiongenerator -nomake pixeltool && \
    make -j${cores} install && \
    cd .. && rm -Rf qt-everywhere*

WORKDIR /build/zxtune
RUN git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "platform=linux\narch=armhf\npackaging?=any\ntools.python=python3\n"\
         "prebuilt.dir=${prebuilt}\ntoolchains.root=${toolchains}\nboost.version=${boost}\nqt.version=${qt}\n"\
         "system.zlib=1\nlibraries.dirs.linux+=\$(linux.armhf.crossroot)/usr/lib/arm-linux-gnueabihf\nlibraries.linux+=expat\n" > variables.mak
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
