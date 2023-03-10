ARG BASE=alpine:3.9
FROM ${BASE} as builder
RUN apk add --update --no-cache build-base wget git gcc cmake make yaml-dev libcurl curl-dev libmicrohttpd-dev util-linux-dev ncurses-dev

ENV CBOR_VERSION=0.5.0
RUN mkdir /tmp/cbor \
  && cd /tmp/cbor \
  && wget -O - https://github.com/PJK/libcbor/archive/v${CBOR_VERSION}.tar.gz | tar -z -x -f - \
  && sed -e 's/-flto//' -i libcbor-${CBOR_VERSION}/CMakeLists.txt \
  && cmake -DCMAKE_BUILD_TYPE=Release -DCBOR_CUSTOM_ALLOC=ON libcbor-${CBOR_VERSION} \
  && make \
  && make install

RUN mkdir /tmp/sdk
COPY VERSION /tmp/sdk
COPY src /tmp/sdk/src
COPY include /tmp/sdk/include
COPY scripts /tmp/sdk/scripts
COPY LICENSE /tmp/sdk
COPY Attribution.txt /tmp/sdk
RUN cd /tmp/sdk \
  && ./scripts/build.sh \
  && make -C build/release install

FROM alpine:3.9
MAINTAINER IOTech <support@iotechsys.com>

RUN apk add --update --no-cache build-base wget git gcc cmake make yaml curl libmicrohttpd libuuid

COPY --from=builder /usr/local/include/iot /usr/local/include/iot
COPY --from=builder /usr/local/include/edgex /usr/local/include/edgex
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/lib64 /usr/local/lib64
COPY --from=builder /usr/local/share/device-sdk-c /usr/local/share/device-sdk-c