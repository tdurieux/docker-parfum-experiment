ARG GOLANG_VER
FROM quay.io/gravitational/debian-venti:go${GOLANG_VER}

ARG PROTOC_VER
ARG PROTOC_PLATFORM
ARG GOGO_PROTO_TAG
ARG GRPC_GATEWAY_TAG
ARG GOLANGCI_VER
ARG UID
ARG GID

ENV DEBIAN_FRONTEND noninteractive
ENV TARBALL protoc-${PROTOC_VER}-${PROTOC_PLATFORM}.zip
ENV GRPC_GATEWAY_ROOT /gopath/src/github.com/grpc-ecosystem/grpc-gateway
ENV GOGOPROTO_ROOT /gopath/src/github.com/gogo/protobuf
ENV PROTOC_URL https://github.com/google/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-${PROTOC_PLATFORM}.zip

RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b $GOPATH/bin v${GOLANGCI_VER}

# install development libraries used when compiling fio
RUN --mount=type=cache,sharing=locked,id=gravity-aptlib,target=/var/lib/apt \
    --mount=type=cache,sharing=locked,id=gravity-aptcache,target=/var/cache/apt \
           apt-get -q -y update --fix-missing && apt-get -q --no-install-recommends -y install libaio-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN getent group  $GID || groupadd builder --gid=$GID -o; \
    getent passwd $UID || useradd builder --uid=$UID --gid=$GID --create-home --shell=/bin/sh;

RUN (mkdir -p /opt/protoc && \
     mkdir -p /.cache && \
     chown -R $UID:$GID /gopath && \
     chown -R $UID:$GID /opt/protoc && \
     chmod 777 /.cache && \
     chmod 777 /tmp)

USER $UID:$GID

ENV LANGUAGE="en_US.UTF-8" \
     LANG="en_US.UTF-8" \
     LC_ALL="en_US.UTF-8" \
     LC_CTYPE="en_US.UTF-8" \
     GOPATH="/gopath" \
     PATH="$PATH:/opt/protoc/bin:/opt/go/bin:/gopath/bin"

RUN set -ex && \
	wget --quiet -O /tmp/${TARBALL} ${PROTOC_URL} && \
	unzip -d /opt/protoc /tmp/${TARBALL} && \
	mkdir -p /gopath/src/github.com/gogo/ /gopath/src/github.com/grpc-ecosystem && \
	git clone https://github.com/gogo/protobuf --branch ${GOGO_PROTO_TAG} --depth 1 /gopath/src/github.com/gogo/protobuf && \
	cd /gopath/src/github.com/gogo/protobuf && \
	make install && \
	git clone https://github.com/grpc-ecosystem/grpc-gateway --branch ${GRPC_GATEWAY_TAG} --depth 1 /gopath/src/github.com/grpc-ecosystem/grpc-gateway && \
	cd /gopath/src/github.com/grpc-ecosystem/grpc-gateway && \
	go install ./protoc-gen-grpc-gateway

ENV PROTO_INCLUDE "/usr/local/include":"/gopath/src":"${GRPC_GATEWAY_ROOT}/third_party/googleapis":"${GOGOPROTO_ROOT}/gogoproto"

VOLUME ["/gopath/src/github.com/gravitational/gravity"]
