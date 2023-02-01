FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -qq update \
 && apt-get -qq upgrade \
 && apt-get install --no-install-recommends -y \
        cmake \
	make \
        g++ \
        libmuparser-dev \
        libqalculate-dev \
        libqt5charts5-dev \
        libqt5svg5-dev \
        libqt5x11extras5-dev \
        python3-dev \
        qtbase5-dev \
        qtdeclarative5-dev && rm -rf /var/lib/apt/lists/*;

COPY . /src
WORKDIR /build
RUN rm -rf * && cmake /src && make
