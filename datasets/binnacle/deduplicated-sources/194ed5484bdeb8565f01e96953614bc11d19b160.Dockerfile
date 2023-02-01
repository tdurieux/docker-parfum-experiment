FROM debian:stretch-slim
ARG cores=12
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates wget git make zip bzip2 python3-minimal \
      xz-utils clang patch icnsutils graphicsmagick-imagemagick-compat genisoimage cmake zlib1g-dev libbz2-dev libxml2-dev libssl-dev

ENV prebuilt=/build/prebuilt toolchains=/build/toolchains

#based on https://github.com/multiarch/crossbuild
#Problems with wget -q https://github.com/phracker/MacOSX-SDKs
#-sdk10.7 has no crt1.10.6.o which is on 10.10
#-sdk10.10 has no libc++ which is on 10.7
ENV OSX_VERSION_MIN=10.6 triplet=x86_64-apple-darwin14
RUN mkdir -p ${toolchains}/${triplet} && cd ${toolchains} && \
    git clone https://github.com/tpoechtrager/osxcross && \
    ln -sT ${toolchains}/${triplet} osxcross/target && \
    wget -q https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX10.10.sdk.tar.xz -P osxcross/tarballs && \
    (cd osxcross && git checkout 6a46fa5e && (yes "" | JOBS=${cores} ./build.sh) && \
    mv tools target/ ) && \
    rm -Rf osxcross

ENV execprefix=${toolchains}/${triplet}/bin/${triplet}-

RUN cd ${toolchains} && \
    git clone https://github.com/vitamin-caig/libdmg-hfsplus.git && \
    (cd libdmg-hfsplus && cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && make && make install) && \
    rm -Rf libdmg-hfsplus

ENV boost=1.70.0
RUN cd /build && \
    bash -c "wget -q https://dl.bintray.com/boostorg/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    cd boost_* && ./bootstrap.sh --with-toolset=clang && \
    echo "using clang : 3.8 : ${execprefix}clang : <archiver>${execprefix}ar <ranlib>${execprefix}ranlib <cxxflags>-stdlib=libc++ ;" > tools/build/src/user-config.jam
RUN cd /build/boost_* && \
    ./bjam toolset=clang-3.8 link=static threading=multi target-os=darwin variant=release address-model=64 --layout=system \
      --with-filesystem --with-locale --with-program_options --with-system -j${cores} \
      --includedir=${prebuilt}/boost-${boost}/include --libdir=${prebuilt}/boost-${boost}-darwin-x86_64/lib install && \
    cd .. && rm -Rf boost_*

ENV qt=4.8.6
#qt crossbuild is not supported now
#root https://www.dropbox.com/sh/j879ottiu1tecsx/AAD4mXm8R1eTaslWKdGv3SiGa?dl=0
RUN apt-get install -y --no-install-recommends libqt4-dev-bin && \
    (wget -q 'https://www.dropbox.com/sh/j879ottiu1tecsx/AAB-3KaCZzsS-_fxwr_-6cvGa/20180201/prebuilt/qt/qt-4.8.6-darwin-x86_64.tar.bz2?dl=0' -O - | tar -xj -C ${prebuilt})

WORKDIR /build/zxtune
RUN git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "platform=darwin\narch=x86_64\npackaging=dmg\ntools.python=python3\n"\
         "prebuilt.dir=${prebuilt}\ntoolchains.root=${toolchains}\n"\
         "darwin.x86_64.execprefix=${execprefix}\nboost.version=${boost}\n"\
         "qt.version=${qt}\ntools.uic=uic\ntools.moc=moc\ntools.rcc=rcc" > variables.mak

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/zxtune-qt"]
