FROM --platform=$TARGETPLATFORM calico/go-build:v0.57 as felix-builder
ARG GOPROXY
ENV GOPROXY $GOPROXY
ENV GIT_BRANCH=v3.20.2
ENV GIT_COMMIT=ab06c3940caa8ac201f85c1313b2d72d724409d2

RUN mkdir -p /go/src/github.com/projectcalico/ && cd /go/src/github.com/projectcalico/ && \
    git clone -b ${GIT_BRANCH} --depth 1 https://github.com/projectcalico/felix.git && \
    cd felix && [ "`git rev-parse HEAD`" = "${GIT_COMMIT}" ]
COPY policy/felix /terway_patch
RUN cd /go/src/github.com/projectcalico/felix && git apply /terway_patch/*.patch
RUN cd /go/src/github.com/projectcalico/felix && \
    go build -v -o bin/calico-felix -v -ldflags \
    "-X github.com/projectcalico/felix/buildinfo.GitVersion=${GIT_BRANCH} \
    -X github.com/projectcalico/felix/buildinfo.BuildDate=$(date -u +'%FT%T%z') \
    -X github.com/projectcalico/felix/buildinfo.GitRevision=${GIT_COMMIT} \
    -B 0x${GIT_COMMIT}" "github.com/projectcalico/felix/cmd/calico-felix" && \
    ( ! $(readelf -d bin/calico-felix | grep -q NEEDED) || ( echo "Error: bin/calico-felix was not statically linked"; false )) \
    && chmod +x /go/src/github.com/projectcalico/felix/bin/calico-felix

FROM --platform=$TARGETPLATFORM quay.io/cilium/cilium-builder:6ad397fc5d0e2ccba203d5c0fe5a4f0a08f6fb5a@sha256:d760b821c46ce41361a2d54386b12fd9831fbc0ba36539b86604706dd68f05d1 as cilium-builder
ARG GOPROXY
ENV GOPROXY $GOPROXY
ARG CILIUM_SHA=""
LABEL cilium-sha=${CILIUM_SHA}
LABEL maintainer="maintainer@cilium.io"
WORKDIR /go/src/github.com/cilium
RUN rm -rf cilium
ENV GIT_TAG=v1.10.1
ENV GIT_COMMIT=e6f34c3c98fe2e247fde581746e552d8cb18c33c
RUN git clone -b $GIT_TAG --depth 1 https://github.com/cilium/cilium.git && \
    cd cilium && \
    [ "`git rev-parse HEAD`" = "${GIT_COMMIT}" ]
COPY policy/cilium /cilium_patch
RUN cd cilium && git apply /cilium_patch/*.patch
ARG NOSTRIP
ARG LOCKDEBUG
ARG V
ARG LIBNETWORK_PLUGIN
#
# Please do not add any dependency updates before the 'make install' here,
# as that will mess with caching for incremental builds!
#
RUN cd cilium && make NOSTRIP=$NOSTRIP LOCKDEBUG=$LOCKDEBUG PKG_BUILD=1 V=$V LIBNETWORK_PLUGIN=$LIBNETWORK_PLUGIN \
    SKIP_DOCS=true DESTDIR=/tmp/install clean-container build-container install-container
RUN cp /tmp/install/opt/cni/bin/cilium-cni /tmp/install/usr/bin/

FROM scratch
COPY --from=felix-builder /go/src/github.com/projectcalico/felix/bin/calico-felix /bin/calico-felix
COPY --from=cilium-builder /tmp/install/ /tmp/install/