ARG BASE_BRANCH
ARG SOURCE=/go/src/github.com/submariner-io/lighthouse

FROM --platform=${BUILDPLATFORM} quay.io/submariner/shipyard-dapper-base:${BASE_BRANCH} AS builder
ARG SOURCE
ARG TARGETPLATFORM

COPY . ${SOURCE}

RUN make -C ${SOURCE} LOCAL_BUILD=1 bin/${TARGETPLATFORM}/lighthouse-coredns

FROM --platform=${TARGETPLATFORM} debian:stable-slim AS certificates
ARG SOURCE
ARG TARGETPLATFORM

RUN apt-get update && apt-get -y --no-install-recommends install ca-certificates && update-ca-certificates && rm -rf /var/lib/apt/lists/*;

FROM --platform=${TARGETPLATFORM} scratch
ARG SOURCE
ARG TARGETPLATFORM

COPY --from=certificates /etc/ssl/certs /etc/ssl/certs
COPY --from=builder ${SOURCE}/bin/${TARGETPLATFORM}/lighthouse-coredns /usr/local/bin/

EXPOSE 53 53/udp
EXPOSE 9153 9153/tcp

ENTRYPOINT ["/usr/local/bin/lighthouse-coredns"]
