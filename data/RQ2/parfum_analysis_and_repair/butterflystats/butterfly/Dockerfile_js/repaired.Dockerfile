FROM ubuntu:artful

RUN apt-get update && apt-get install --no-install-recommends -y \
	gcc-5 \
	build-essential \
	unzip \
	autoconf \
	m4 \
	libtool \
	cmake \
	libsnappy-dev \
	wget \
	git \
	emscripten && rm -rf /var/lib/apt/lists/*;

RUN mkdir /protobuf
WORKDIR /protobuf

RUN wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz && \
	tar xzf protobuf-2.6.1.tar.gz && \
	cd protobuf-2.6.1 && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	make && \
	make check && \
	make install && \
  ldconfig && rm protobuf-2.6.1.tar.gz

RUN mkdir /snappy
WORKDIR /snappy

RUN wget https://github.com/google/snappy/archive/1.1.7.tar.gz && \
	tar xzf 1.1.7.tar.gz && \
	cd snappy-1.1.7 && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make && \
	make install && rm 1.1.7.tar.gz

COPY . /butterfly

WORKDIR /butterfly

RUN git submodule init && \
	git submodule update

RUN cd build && \
	CC=emcc CXX=em++ cmake -I/usr/local/include .. -DWITH_JAVASCRIPT_BINDINGS=1  && \
	make -j6
