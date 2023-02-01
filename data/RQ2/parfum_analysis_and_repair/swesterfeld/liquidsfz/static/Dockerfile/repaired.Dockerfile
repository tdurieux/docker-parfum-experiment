# EXPERIMENTAL file to build statically linked LV2

FROM ubuntu:16.04

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dpkg-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf-archive && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lv2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;

ENV CC gcc-9
ENV CXX g++-9

ADD . /liquidsfz
WORKDIR /liquidsfz

ENV PKG_CONFIG_PATH=/liquidsfz/static/prefix/lib/pkgconfig
ENV PKG_CONFIG="pkg-config --static"
RUN cd static && ./build-deps.sh
RUN ./autogen.sh --prefix=/usr/local/liquidsfz --with-static-cxx --without-jack
RUN make -j16
RUN make install

# docker build -t liquidsfz .
# docker run -v /tmp:/data -t liquidsfz tar Cczfv /usr/local /data/liquidsfz-static.tar.gz liquidsfz
# docker run -v /tmp:/data -it liquidsfz
# docker cp ...:/usr/local/lib/lv2/liquidsfz.lv2/liquidsfz_lv2.so /tmp
