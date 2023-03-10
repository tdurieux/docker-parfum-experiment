ARG BASE_BRANCH
ARG SOURCE=/go/src/github.com/submariner-io/submariner-operator

FROM --platform=${BUILDPLATFORM} quay.io/submariner/shipyard-dapper-base:${BASE_BRANCH} AS builder
ARG SOURCE
ARG TARGETPLATFORM

COPY . ${SOURCE}

RUN make -C ${SOURCE} LOCAL_BUILD=1 bin/${TARGETPLATFORM}/submariner-operator

FROM --platform=${TARGETPLATFORM} scratch
ARG SOURCE
ARG TARGETPLATFORM

ENV USER_UID=1001 PATH=/

# install operator binary
COPY --from=builder ${SOURCE}/bin/${TARGETPLATFORM}/submariner-operator /submariner-operator

ENTRYPOINT ["/submariner-operator"]

USER ${USER_UID}