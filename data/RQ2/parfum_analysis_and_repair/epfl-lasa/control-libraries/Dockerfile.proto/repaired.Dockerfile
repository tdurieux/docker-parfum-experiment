FROM ubuntu:20.04 as build-stage
ARG PROTOBUF_VERSION=3.17.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    cmake \
    g++ \
    gcc \
    libtool \
    make \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget -O protobuf-cpp-"${PROTOBUF_VERSION}".tar.gz \
    https://github.com/protocolbuffers/protobuf/releases/download/v"${PROTOBUF_VERSION}"/protobuf-cpp-"${PROTOBUF_VERSION}".tar.gz \
    && tar -xzf protobuf-cpp-"${PROTOBUF_VERSION}".tar.gz \
    && rm protobuf-cpp-"${PROTOBUF_VERSION}".tar.gz

WORKDIR /tmp/protobuf-"${PROTOBUF_VERSION}"
RUN ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install


FROM ubuntu:20.04 as google-dependencies
COPY --from=build-stage /usr/local/include/google /usr/local/include/google
COPY --from=build-stage /usr/local/lib/libproto* /usr/local/lib/
COPY --from=build-stage /usr/local/bin/protoc /usr/local/bin
RUN ldconfig
