ARG VERSION=1.6.8

FROM golang:1.14 as build

ARG VERSION=1.6.8
ARG TARGETPLATFORM

ENV GO111MODULE=on \
  CGO_ENABLED=0

WORKDIR /go/src/github.com/istio/istio

RUN git clone --depth 1 -b ${VERSION} https://github.com/istio/istio.git .

RUN export GOOS=$(echo ${TARGETPLATFORM} | cut -d / -f1) && \
  export GOARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) && \
  export GOARM=$(echo ${TARGETPLATFORM} | cut -d / -f3 | cut -c2-) && \
  go get github.com/jteeuwen/go-bindata/go-bindata@6025e8de665b && \
  ./operator/scripts/create_assets_gen.sh && \
  STATIC=0 LDFLAGS='-extldflags -static -s -w' ./common/scripts/gobuild.sh /go/src/github.com/istio/istio/out/pilot-agent ./pilot/cmd/pilot-agent

FROM istio/proxyv2:${VERSION} as proxyv2
FROM apulistech/istio-envoy as envoy

FROM apulistech/istio-base

ARG VERSION=1.6.8
ARG ENVOY_VERSION=""

COPY --from=proxyv2 /var/lib/istio/envoy/ /var/lib/istio/envoy/
COPY --from=proxyv2 /etc/istio/extensions/ /etc/istio/extensions/

RUN chown -R istio-proxy /var/lib/istio

# ADD https://github.com/querycap/istio-envoy-arm64/releases/download/${VERSION}/envoy /usr/local/bin/envoy

COPY --from=envoy /envoy/envoy /usr/local/bin/envoy

RUN chmod +x /usr/local/bin/envoy

# Environment variable indicating the exact proxy sha - for debugging or version-specific configs
ENV ISTIO_META_ISTIO_PROXY_SHA ${ENVOY_VERSION}
# Environment variable indicating the exact build, for debugging
ENV ISTIO_META_ISTIO_VERSION ${VERSION}

COPY --from=build /go/src/github.com/istio/istio/out/pilot-agent /usr/local/bin/pilot-agent

# The pilot-agent will bootstrap Envoy.
ENTRYPOINT ["/usr/local/bin/pilot-agent"]