ARG BASE_IMAGE_ARCH=amd64

FROM debian:11 as envoy
ARG ENVOY_VERSION
ARG ARCH

ADD /build/artifacts-linux-$ARCH/envoy/envoy-$ENVOY_VERSION-alpine /envoy

RUN apt-get update && \
    apt-get install --no-install-recommends -y libcap2-bin && rm -rf /var/lib/apt/lists/*;
RUN setcap cap_net_bind_service+ep /envoy

FROM --platform=linux/$BASE_IMAGE_ARCH gcr.io/distroless/base-debian11:debug-nonroot
ARG ARCH

ADD /build/artifacts-linux-$ARCH/kuma-dp/kuma-dp /usr/bin
COPY --from=envoy /envoy /usr/bin/envoy
ADD /build/artifacts-linux-$ARCH/coredns/coredns /usr/bin

COPY /tools/releases/templates/LICENSE \
    /tools/releases/templates/README \
    /kuma/

COPY /tools/releases/templates/NOTICE /kuma/

USER nobody:nobody

ENTRYPOINT ["kuma-dp"]
