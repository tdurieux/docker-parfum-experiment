FROM ubuntu:18.04

RUN apt-get update && apt-get --yes --no-install-recommends install git cmake gcc-6 g++-6 curl libssl-dev net-tools && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

ARG hash=bcd70c0147c52e62ad173e0e737e50f7d6819e0b

RUN git clone https://github.com/h2o/quicly.git
RUN cd quicly && git checkout $hash && git submodule update --init --recursive && cmake -DOPENSSL_ROOT_DIR=$HOME/openssl-build . && make

WORKDIR quicly

EXPOSE 4433/udp

HEALTHCHECK --start-period=3s --interval=5s CMD netstat -an | grep 4433

ENTRYPOINT ["./cli", "-c", "t/assets/server.crt", "-k", "t/assets/server.key", "-vv", "-x", "X25519", "-a", "http/1.1", "0.0.0.0", "4433"]
