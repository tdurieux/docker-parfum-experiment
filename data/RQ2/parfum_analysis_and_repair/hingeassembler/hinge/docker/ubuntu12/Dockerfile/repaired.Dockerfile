FROM ubuntu:12.04

RUN apt-get update

RUN apt-get install --no-install-recommends zlibc zlib1g zlib1g-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common python-software-properties -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-graph-dev -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz --no-check-certificate && tar xf cmake-3.2.2.tar.gz && rm cmake-3.2.2.tar.gz
RUN cd cmake-3.2.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

RUN cmake --version

RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update; apt-get install --no-install-recommends gcc-4.8 g++-4.8 -y && rm -rf /var/lib/apt/lists/*;
RUN gcc-4.8 --version
RUN which gcc-4.8


ADD . /hinge/
WORKDIR /hinge/
RUN ./utils/build.sh
