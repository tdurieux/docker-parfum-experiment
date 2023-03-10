FROM quay.io/pypa/manylinux1_x86_64
ARG PROTOBUF_VERSION='3.15.1'
ENV PLAT='manylinux1_x86_64'

# Install libprotobuf and protoc for C++
# Taken mostly from:
# https://github.com/protocolbuffers/protobuf/tree/master/src
#
# NOTE: the README's instructions are misleading; this will
# build for all languages, not just C++.
# See https://github.com/protocolbuffers/protobuf/issues/779.

WORKDIR /opt
RUN set -ex \
    && yum update -y \
    && yum install -y \
        autoconf \
        automake \
        gcc-c++ \
        glibc-headers \
        gzip \
        libtool \
        make \
        zlib-devel \
    && curl -f -Lo /opt/protobuf.tar.gz \
        "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-cpp-${PROTOBUF_VERSION}.tar.gz" \
    && tar -xzvf protobuf.tar.gz \
    && rm -f protobuf.tar.gz \
    && pushd "protobuf-${PROTOBUF_VERSION}" \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-zlib --disable-debug \
    && make \
    && make install \
    && ldconfig --verbose \
    && popd \
    && rm -rf "protobuf-${PROTOBUF_VERSION}" \
    && protoc --version \
    && pkg-config --cflags protobuf \
    && pkg-config --libs protobuf && rm -rf /var/cache/yum
