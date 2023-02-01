# build statically linked LV2/VST

FROM ubuntu:16.04

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

RUN true && apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dpkg-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf-archive && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjack-jackd2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lv2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y quilt && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxext-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mesa-common-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgl-dev && rm -rf /var/lib/apt/lists/*;

ENV CC gcc-9
ENV CXX g++-9

ADD . /spectmorph
WORKDIR /spectmorph

ENV PKG_CONFIG_PATH=/spectmorph/static/prefix/lib/pkgconfig
ENV PKG_CONFIG="pkg-config --static"
RUN cd static && ./build-deps.sh
ENV CPPFLAGS="-I/spectmorph/static/prefix/include"
RUN ./autogen.sh --prefix=/usr/local/spectmorph --with-static-cxx --without-qt --without-jack --with-fonts
RUN make clean
RUN make -j16
RUN make install
RUN cd lv2 && rm -f spectmorph_lv2.so.static && make spectmorph_lv2.so.static
RUN cd vst && rm -f spectmorph_vst.so.static && make spectmorph_vst.so.static
