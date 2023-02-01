FROM ubuntu


RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git-all && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssl libssl-dev && rm -rf /var/lib/apt/lists/*;


## Install sdsl
### Install cmake
WORKDIR /git
RUN wget https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz
RUN tar xf cmake-3.11.4.tar.gz && rm cmake-3.11.4.tar.gz
WORKDIR /git/cmake-3.11.4
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
ENV PATH="/git/cmake-3.11.4/:/git/cmake-3.11.4/bin/:${PATH}"

WORKDIR /git
RUN git clone https://github.com/simongog/sdsl-lite.git
RUN cd sdsl-lite
WORKDIR /git/sdsl-lite
RUN ./install.sh /usr/local/

COPY ./ /mantis
WORKDIR /mantis

RUN mkdir -p build
RUN cd build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local
RUN make install
CMD mantis

