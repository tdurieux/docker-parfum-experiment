FROM archlinux/base:latest
ARG cores=12
RUN yes | pacman -Syu sudo awk fakeroot file make git zip python \
      binutils gcc diffutils patch wget cmake pkg-config which && \
    pacman-key --init && pacman-key --populate archlinux && \
    useradd -m -s /bin/bash -U -G wheel -d /build build && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo -e 'MAKEFLAGS="-j${cores}"\nSRCDEST=/build/sources\n' >> /etc/makepkg.conf && \
    rm -Rf /var/cache/pacman
USER build
WORKDIR /build
COPY mingw-w64 .
RUN gpg --recv 93BDB53CD4EBC740 13FCEF89DD9E3C4F A328C3A2C3C45C06 && \
    mkdir sources && sudo chmod o+w * && \
    for pkg in headers binutils headers-bootstrap gcc-base crt winpthreads gcc pkg-config cmake win-iconv ;\
    do \
      (cd ${pkg} && makepkg && yes | sudo pacman -U *.pkg.tar.xz) && \
      rm -Rf ${pkg} ;\
    done && \
    rm -Rf sources

ENV prebuilt=/build/prebuilt execprefix=x86_64-w64-mingw32-

ENV boost=1.70.0
RUN bash -c "wget -q https://dl.bintray.com/boostorg/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh && \
    echo "using gcc : windows : ${execprefix}g++ ;" > tools/build/src/user-config.jam && \
    ./bjam toolset=gcc-windows link=static threading=multi target-os=windows variant=release --layout=system \
      address-model=64 cxxflags=-mno-ms-bitfields cxxflags=-mmmx cxxflags=-msse cxxflags=-msse2 cxxflags=-ffunction-sections cxxflags=-fdata-sections \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-mingw-x86_64/lib install && \
    cd .. && rm -Rf boost_*

ENV qt=4.8.7
RUN bash -c "wget -q http://download.qt.io/archive/qt/${qt%.*}/${qt}/qt-everywhere-opensource-src-${qt}.tar.gz -O - | tar -xz" && \
    cd qt-everywhere* && \
    ./configure -xplatform win32-g++ -device-option CROSS_COMPILE=${execprefix} -prefix ${prebuilt}/qt-${qt}-mingw-x86_64 \
      -release -opensource -static -fast -confirm-license \
      -no-accessibility -no-sql-sqlite -no-qt3support -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon -no-phonon-backend \
      -no-svg -no-webkit -no-javascript-jit -no-script -no-scripttools -no-declarative -no-declarative-debug \
      -qt-zlib -qt-libpng \
      -no-gif -no-libtiff -no-libmng -no-libjpeg -no-openssl -no-nis -no-cups -no-pch -no-dbus \
      -nomake demos -nomake examples -nomake docs -nomake translations -nomake assistant -nomake qdoc3 -nomake qtracereplay -nomake linguist \
      -nomake qt3to4 -nomake qcollectiongenerator -nomake pixeltool && \
    make -j${cores} install && \
    cd .. && rm -Rf qt-everywhere*

RUN mkdir zxtune && sudo chmod o+w zxtune && cd zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo -e "platform=mingw\narch=x86_64\ntools.python=python3\nmingw.execprefix=${execprefix}\n"\
      "prebuilt.dir=${prebuilt}\nboost.version=${boost}\nqt.version=${qt}\n"\
      "host=linux\nembed_file_cmd=cat \$(embedded_files) >> \$@\nmakepkg_cmd=(cd \$(1) && zip -9rD \$(CURDIR)/\$(2) .)\npkg_suffix=zip" > variables.mak

WORKDIR /build/zxtune
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
