ARG BASE_BRANCH
ARG SOURCE=/go/src/github.com/submariner-io/lighthouse

FROM --platform=${BUILDPLATFORM} quay.io/submariner/shipyard-dapper-base:${BASE_BRANCH} AS builder
ARG SOURCE
ARG TARGETPLATFORM

COPY . ${SOURCE}

RUN make -C ${SOURCE} LOCAL_BUILD=1 bin/${TARGETPLATFORM}/lighthouse-agent

FROM --platform=${TARGETPLATFORM} scratch
ARG SOURCE
ARG TARGETPLATFORM

WORKDIR /var/submariner

COPY --from=builder ${SOURCE}/bin/${TARGETPLATFORM}/lighthouse-agent /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/lighthouse-agent", "-alsologtostderr"]