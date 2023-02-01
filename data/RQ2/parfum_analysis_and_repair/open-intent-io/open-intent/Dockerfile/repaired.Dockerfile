FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -y libboost-system1.58-dev \
        libboost-thread1.58-dev libboost-filesystem1.58-dev \
        cmake g++ git \
        doxygen node-gyp nodejs npm clang-format-3.7 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libltdl7 && rm -rf /var/lib/apt/lists/*;

VOLUME /src
WORKDIR /src

RUN ln -s /usr/bin/nodejs /usr/bin/node


