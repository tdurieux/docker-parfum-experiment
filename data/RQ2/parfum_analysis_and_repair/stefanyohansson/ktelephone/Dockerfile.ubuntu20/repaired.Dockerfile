FROM ubuntu:20.04
RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y git cmake g++ qtbase5-dev qtmultimedia5-dev libasound2-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN git clone https://github.com/pjsip/pjproject.git /pjproject
RUN cd /pjproject && \
git checkout 2.10 && \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/lib --enable-static --disable-resample --disable-video --disable-opencore-amr && \
make dep && \
make && \
make install && ldconfig
ADD . /usr/src/ktelephone
WORKDIR /usr/src/ktelephone
RUN mkdir -p build/
WORKDIR /usr/src/ktelephone/build
RUN PKG_CONFIG_PATH=/usr/lib/lib/pkgconfig/ BUILD_STATIC=1 cmake ..
RUN make
