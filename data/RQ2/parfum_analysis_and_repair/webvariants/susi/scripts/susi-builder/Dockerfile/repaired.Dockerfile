FROM debian:jessie
MAINTAINER Tino Rusch <tino.rusch@webvariants.de>

RUN apt-get update

# install basic build tools
RUN apt-get -y --no-install-recommends install cmake make g++ git && rm -rf /var/lib/apt/lists/*;

# install susi dependencies
RUN apt-get -y --no-install-recommends install \
    libssl-dev \
    libboost-system-dev \
    libboost-program-options-dev \
    libmosquitto-dev \
    libmosquittopp-dev \
    libleveldb-dev && rm -rf /var/lib/apt/lists/*;

# clone and build susi
RUN git clone --recursive https://github.com/webvariants/susi
RUN mkdir /susi/build

CMD ["bash","-c","cd /susi && git pull && git submodule foreach git pull origin master && cd build && cmake .. && make -j4 package && cp susi-*.deb /output"]
