# This file works properly only with Docker.
# Assumed that docker.io registry is used.
#
# `podman buildx build` doesn't work at this point because it doesn't support
# the following build arguments that docker set automagically:
#
#   BUILDPLATFORM
#   TARGETPLATFORM

FROM --platform=$BUILDPLATFORM rust:slim-buster AS buildenv
ARG BUILDPLATFORM
ARG TARGETPLATFORM
ENV DEBIAN_FRONTEND=noninteractive
COPY ./docker/build-scripts/vars.* /build-scripts/
COPY ./docker/build-scripts/buildenv.sh /build-scripts/
RUN sh /build-scripts/buildenv.sh alpine $BUILDPLATFORM $TARGETPLATFORM
RUN mkdir -p /build
WORKDIR /build

FROM buildenv AS recdvb-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./docker/build-scripts/recdvb.sh /build-scripts/
RUN sh /build-scripts/recdvb.sh alpine $BUILDPLATFORM $TARGETPLATFORM

FROM buildenv AS recpt1-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./docker/build-scripts/recpt1.sh /build-scripts/
RUN sh /build-scripts/recpt1.sh alpine $BUILDPLATFORM $TARGETPLATFORM

FROM buildenv AS mirakc-arib-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./docker/build-scripts/mirakc-arib.sh /build-scripts/
RUN sh /build-scripts/mirakc-arib.sh alpine $BUILDPLATFORM $TARGETPLATFORM

FROM scratch AS mirakc-tools
COPY --from=recdvb-build /usr/local/bin/recdvb /usr/local/bin/
COPY --from=recpt1-build /usr/local/bin/recpt1 /usr/local/bin/
COPY --from=mirakc-arib-build /build/build/bin/mirakc-arib /usr/local/bin/

FROM buildenv AS mirakc-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./Cargo.* ./
COPY ./mirakc ./mirakc/
COPY ./mirakc-core ./mirakc-core/
COPY ./mirakc-timeshift-fs ./mirakc-timeshift-fs/
COPY ./resources ./resources/
COPY ./docker/build-scripts/mirakc.sh /build-scripts/
RUN sh /build-scripts/mirakc.sh alpine $BUILDPLATFORM $TARGETPLATFORM

FROM alpine AS mirakc
LABEL maintainer="Contributors of mirakc"
ARG TARGETPLATFORM
COPY --from=mirakc-tools /usr/local/bin/* /usr/local/bin/
COPY --from=mirakc-build /usr/local/bin/mirakc /usr/local/bin/
COPY --from=mirakc-build /build/resources/strings.yml /etc/mirakc/strings.yml
COPY --from=mirakc-build /build/resources/mirakurun.openapi.json /etc/mirakurun.openapi.json
RUN apk add --no-cache ca-certificates curl libstdc++ socat tzdata
# dirty hack for linux/arm/v6
RUN if [ "$TARGETPLATFORM" = "linux/arm/v6" ]; then ln -s /lib/ld-musl-armhf.so.1 /lib/ld-musl-arm.so.1; fi
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml
EXPOSE 40772
ENTRYPOINT ["mirakc"]
CMD []

FROM alpine AS mirakc-timeshift-fs
LABEL maintainer="Contributors of mirakc"
COPY --from=mirakc-build /usr/local/bin/mirakc-timeshift-fs /usr/local/bin/
COPY --from=mirakc-build /usr/local/bin/run-mirakc-timeshift-fs /usr/local/bin/
COPY --from=mirakc-build /build/resources/strings.yml /etc/mirakc/strings.yml
COPY --from=mirakc-build /build/resources/mirakurun.openapi.json /etc/mirakurun.openapi.json
RUN apk add --no-cache fuse3 tzdata
# dirty hack for linux/arm/v6