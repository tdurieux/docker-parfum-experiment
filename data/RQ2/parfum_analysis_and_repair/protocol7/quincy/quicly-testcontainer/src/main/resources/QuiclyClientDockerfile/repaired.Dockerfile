FROM ubuntu:18.04

RUN apt-get update && apt-get --yes --no-install-recommends install git cmake gcc-6 g++-6 curl libssl-dev net-tools && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

ARG hash=d4b83ba

RUN git clone https://github.com/h2o/quicly.git
RUN cd quicly && git checkout $hash && git submodule update --init --recursive && cmake -DOPENSSL_ROOT_DIR=$HOME/openssl-build . && make

WORKDIR quicly
