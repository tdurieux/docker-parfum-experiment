FROM debian:stretch-slim
ARG cores=12
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget xz-utils bzip2 git make zip \
      g++ gcc python3-minimal \
      libpulse-dev libclalsadrv-dev zlib1g-dev \
      libxfixes-dev libxrandr-dev libfontconfig-dev && \
    rm -rf /var/lib/apt/lists/*

ENV prebuilt=/build/prebuilt
WORKDIR /build

ENV boost=1.70.0
RUN bash -c "wget -q https://dl.bintray.com/boostorg/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh && \
    ./bjam toolset=gcc link=static threading=multi target-os=linux variant=release --layout=system \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-linux-x86_64/lib install && \
    cd .. && rm -Rf boost_*

ENV qt=4.8.7
RUN bash -c "wget -q http://download.qt.io/archive/qt/${qt%.*}/${qt}/qt-everywhere-opensource-src-${qt}.tar.gz -O - | tar -xz" && \
    cd qt-everywhere* && \
    ./configure -v -platform linux-g++-64 -prefix ${prebuilt}/qt-${qt}-linux-x86_64 \
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
    echo "platform=linux\narch=x86_64\npackaging=any\ntools.python=python3\nsystem.zlib=1\n"\
         "prebuilt.dir=${prebuilt}\nboost.version=${boost}\nqt.version=${qt}\n" > variables.mak
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]
