FROM archlinux/base:latest
ARG cores=12
RUN yes | pacman -Syu sudo awk fakeroot file make git zip python xz \
      binutils gcc mingw-w64-gcc diffutils patch wget cmake pkg-config which && \
    pacman-key --init && pacman-key --populate archlinux && \
    useradd -m -s /bin/bash -U -G wheel -d /build build && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e 'MAKEFLAGS="-j${cores}"\nSRCDEST=/build/sources\n' >> /etc/makepkg.conf && \
    rm -Rf /var/cache/pacman

USER build
WORKDIR /build

ENV prebuilt=/build/prebuilt execprefix=x86_64-w64-mingw32-

ENV boost=1.77.0
RUN bash -c "wget -q https://boostorg.jfrog.io/artifactory/main/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh && \
    echo "using gcc : windows : ${execprefix}g++ ;" > tools/build/src/user-config.jam && \
    ./b2 toolset=gcc-windows link=static threading=multi target-os=windows variant=release --layout=system \
      address-model=64 cxxflags=-mno-ms-bitfields cxxflags=-mmmx cxxflags=-msse cxxflags=-msse2 cxxflags=-ffunction-sections cxxflags=-fdata-sections \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-mingw-x86_64/lib install && \
    cd .. && rm -Rf boost_*

ENV qt=5.15.2
RUN bash -c "wget -q http://download.qt.io/archive/qt/${qt%.*}/${qt}/single/qt-everywhere-src-${qt}.tar.xz -O - | tar -xJ" && \
    cd qt-everywhere* && \
     sed -i '/type_traits/a #  include <limits>' qtbase/src/corelib/global/qglobal.h && \
     ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -v -xplatform win32-g++ -device-option CROSS_COMPILE=${execprefix} -prefix ${prebuilt}/qt-${qt}-mingw-x86_64 -release -opensource -static -confirm-license -no-rpath \
      -no-opengl -no-openvg -no-sql-sqlite \
      -no-ico -no-gif -no-libjpeg -no-openssl -no-cups -no-pch -no-glib \
      -no-feature-testlib \
      -qt-pcre -qt-zlib -qt-libpng \
      -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcharts -skip qtconnectivity -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation \
      -skip qtlottie -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquick3d -skip qtquickcontrols -skip qtquickcontrols2 -skip qtquicktimeline -skip qtremoteobjects \
      -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtsvg -skip qttranslations -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel \
      -skip qtwebengine -skip qtwebglplugin -skip qtwebsockets -skip qtwebview -skip qtxmlpatterns \
      -make libs && \
     make -j${cores} install && \
     cd .. && rm -Rf qt-everywhere*

RUN mkdir zxtune && sudo chmod o+w zxtune && cd zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo -e "platform=mingw\narch=x86_64\ntools.python=python3\nmingw.execprefix=${execprefix}\n" \
      "prebuilt.dir=${prebuilt}\nboost.version=${boost}\nqt.version=${qt}\n"\
      "host=linux\nembed_file_cmd=cat \$(embedded_files) >> \$@\nmakepkg_cmd=(cd \$(1) && zip -9rD \$(CURDIR)/\$(2) .)\npkg_suffix=zip\n" \
      "qt.plugins=QWindowsIntegrationPlugin QWindowsVistaStylePlugin\n" \
      "libraries.qt.system.mingw=qwindows qwindowsvistastyle qtfreetype qtlibpng qtpcre2 qtharfbuzz userenv netapi32 version winmm" \
        "oleaut32 wtsapi32 dwmapi uxtheme\n" \
      "libraries.qt.mingw=FontDatabaseSupport EventDispatcherSupport ThemeSupport WindowsUIAutomationSupport\n" > variables.mak

WORKDIR /build/zxtune
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
