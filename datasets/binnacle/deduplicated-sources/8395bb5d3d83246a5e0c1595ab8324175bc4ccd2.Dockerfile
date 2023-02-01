#
#  @author raver119@gmail.com
#  @author @sshepel
#
FROM ubuntu:bionic as builder

LABEL Description="GraphServer container"  Vendor="SkyMind.ai"  Version="1.0.0-SNAPSHOT"

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        git maven gcc g++ automake cmake build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev libgomp1 libprotobuf-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PROTOBUF_HOME /opt/protobuf

RUN git clone https://github.com/grpc/grpc \
            && cd grpc \
            && git checkout v1.14.1 \
            && git submodule update --init \
            && make -j 6 \
            && make install

RUN git clone https://github.com/deeplearning4j/deeplearning4j \
    && cd deeplearning4j/libnd4j/server \
    && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release \
    && make -j 6

FROM ubuntu:bionic

COPY --from=builder /deeplearning4j/libnd4j/server/GraphServer /app/GraphServer
COPY --from=builder /usr/local/lib/libgrpc* /usr/local/lib/

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        libgomp1 libprotobuf10 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG C.UTF-8

EXPOSE 40123/tcp

CMD ["/app/GraphServer", "-p", "40123"]