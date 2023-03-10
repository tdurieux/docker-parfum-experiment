FROM debian:stretch-slim
ARG cores=12
#Do not remove /var/lib/apt/lists due to later download
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates gnupg2 && \
    (wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - ) && \
    echo "deb [arch=amd64] http://deb.debian.org/debian stretch main\ndeb [arch=armhf] http://mirrordirector.raspbian.org/raspbian/ stretch main rpi" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends xz-utils bzip2 git make zip g++ python3-minimal sudo nano && \
    useradd -m -s /bin/bash -U -G users,sudo -d /build build && \
    echo '%sudo ALL = (root) NOPASSWD: ALL' >> /etc/sudoers && rm -rf /var/lib/apt/lists/*;

USER build
WORKDIR /build

ENV prebuilt=/build/prebuilt toolchains=/build/toolchains

# Toolchain from https://github.com/abhiTronix/raspberry-pi-cross-compilers
ENV gcc=10.2.0
RUN mkdir -p ${toolchains} && cd ${toolchains} && \
    (wget -q https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Stretch/GCC%20${gcc}/Raspberry%20Pi%201%2C%20Zero/cross-gcc-${gcc}-pi_0-1.tar.gz -O - | tar -xz) && \
    mv cross-pi-gcc* armhf-linux

ENV boost=1.77.0
RUN bash -c "wget -q https://boostorg.jfrog.io/artifactory/main/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh && \
    echo "using gcc : ${gcc} : ${toolchains}/armhf-linux/bin/arm-linux-gnueabihf-g++  ;" > tools/build/src/user-config.jam && \
    ./b2 toolset=gcc-${gcc} link=static threading=multi target-os=linux variant=release --layout=system \
      cflags="-march=armv6 -mfpu=vfp -mfloat-abi=hard -ffunction-sections -fdata-sections" \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-linux-armhf/lib install && \
    cd .. && rm -Rf boost_*

# Cross-root
ENV crossroot=${prebuilt}/root-linux-armhf
RUN mkdir -p ${crossroot} && cd ${crossroot} && \
    bash -c "apt-get download {libxcb{1,-icccm4,-image0,-keysyms1,-randr0,-render0,-render-util0,-shape0,-shm0,-util0,-xfixes0,-xinerama0}{,-dev},libxcb-{sync,xkb}{1,-dev},\
libx11-dev,lib{fontconfig1,freetype6}{,-dev},libxkbcommon{0,-dev},libxkbcommon-x11-{0,dev},lib{bsd0,c6,expat1,xau6,xdmcp6},\
libpng{16-16,-dev},\
zlib1g{,-dev},\
lib{asound2,pulse}-dev}:armhf" && \
    (for pkg in *.deb ; do dpkg -x ${pkg} . ; done) && \
    rm *.deb
    #echo "cd ${prebuilt}/root-linux-armhf && apt-get download \$1:armhf && dpkg -x \$1_*.deb . && echo \$1 >> packages.lst" > add_lib.sh

ENV qt=5.15.2
RUN bash -c "wget -q http://download.qt.io/archive/qt/${qt%.*}/${qt}/single/qt-everywhere-src-${qt}.tar.xz -O - | tar -xJ" && \
    cd qt-everywhere* && \
    (cd qtbase/mkspecs/devices/linux-rasp-pi-g++ && \
      echo "include(../common/linux_device_pre.conf)\n"\
        "QMAKE_CFLAGS = -march=armv6 -mfpu=vfp\n"\
        "DISTRO_OPTS += hard-float\n"\
        "EXTRA_INCLUDEPATH += \$\${CROSS_ROOT}/usr/include\n"\
        "EXTRA_LIBDIR += \$\${CROSS_ROOT}/usr/lib/arm-linux-gnueabihf\n"\
        "QMAKE_LFLAGS=-Wl,-rpath-link,\$\${CROSS_ROOT}/usr/lib/arm-linux-gnueabihf -Wl,-rpath-link,\$\${CROSS_ROOT}/lib/arm-linux-gnueabihf\n"\
        "include(../common/linux_arm_device_post.conf)\n"\
        "load(qt_config)\n" > qmake.conf) && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -v -device linux-rasp-pi-g++ -prefix ${prebuilt}/qt-${qt}-linux-armhf -device-option CROSS_COMPILE=${toolchains}/armhf-linux/bin/arm-linux-gnueabihf- -device-option CROSS_ROOT=${prebuilt}/root-linux-armhf \
      -release -opensource -static -confirm-license \
      -no-opengl -no-openvg -no-sql-sqlite -no-rpath \
      -no-ico -no-gif -no-libjpeg -no-openssl -no-cups -no-pch -no-glib \
      -no-directfb -no-evdev -no-tslib -no-linuxfb -no-kms -qpa xcb \
      -no-feature-testlib \
      -qt-pcre -system-zlib -system-libpng -fontconfig \
      -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcharts -skip qtconnectivity -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation \
      -skip qtlottie -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquick3d -skip qtquickcontrols -skip qtquickcontrols2 -skip qtquicktimeline -skip qtremoteobjects \
      -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtsvg -skip qttranslations -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel \
      -skip qtwebengine -skip qtwebglplugin -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtxmlpatterns \
      -make libs && \
    make -j${cores} install && \
    cd .. && rm -Rf qt-everywhere*

#Sources. Add special library dir for libz
RUN mkdir -p /build/zxtune && cd /build/zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "platform=linux\narch=armhf\npackaging?=any\ntools.python=python3\n"\
         "prebuilt.dir=${prebuilt}\ntoolchains.root=${toolchains}\nboost.version=${boost}\nqt.version=${qt}\n"\
         "system.zlib=1\nlibraries.dirs.linux+=\$(linux.armhf.crossroot)/usr/lib/arm-linux-gnueabihf\n"\
         "qt.plugins=QXcbIntegrationPlugin\nlibraries.qt.system.linux=qxcb qtpcre2 png16 qtharfbuzz fontconfig freetype"\
           "xcb xcb-icccm xcb-image xcb-keysyms xcb-randr xcb-render xcb-render-util xcb-shape xcb-shm xcb-sync xcb-xfixes xcb-xinerama xcb-xkb xkbcommon xkbcommon-x11\n"\
         "libraries.qt.linux=XcbQpa XkbCommonSupport ThemeSupport DBus EdidSupport FontDatabaseSupport ServiceSupport" > variables.mak

WORKDIR /build/zxtune
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
