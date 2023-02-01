FROM ubuntu:15.10

MAINTAINER Paweł Nowak pawel@livetalk.lol

RUN apt-get update

# Install build tools.
RUN apt-get install --no-install-recommends -y build-essential automake libtool g++ git cmake && rm -rf /var/lib/apt/lists/*;

# Install boost.
RUN apt-get install --no-install-recommends -y libboost-dev libboost-context-dev libboost-thread-dev libboost-system-dev && rm -rf /var/lib/apt/lists/*;

# Install and compile google test.
RUN apt-get install --no-install-recommends -y libgtest-dev && cd /usr/src/gtest && cmake . && make && cp lib*.a /usr/lib && rm -rf /var/lib/apt/lists/*;

# Install tlmalloc.
RUN apt-get install --no-install-recommends -y libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;

# Install libuv.
COPY libuv/ /usr/src/libuv/
RUN cd /usr/src/libuv && sh autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install

# Build and install fiberize.
COPY fiberize/ /usr/src/fiberize/
RUN mkdir -p /tmp/build/fiberize && cd /tmp/build/fiberize && cmake /usr/src/fiberize/ -DCMAKE_BUILD_TYPE=Release && make -j8 && make -j8 test && make install
RUN rm -R /tmp/build
