FROM alpine AS build

ARG CHANNEL=stable
ARG VERSION=1.2.2
ARG ARCH=amd64

RUN mkdir /build
WORKDIR /build
RUN apk add --no-cache curl tar

RUN curl -vsLo tailscale.tar.gz "https://pkgs.tailscale.com/${CHANNEL}/tailscale_${VERSION}_${ARCH}.tgz" && \
    tar xvf tailscale.tar.gz && \
    mv "tailscale_${VERSION}_${ARCH}/tailscaled" . && \
    mv "tailscale_${VERSION}_${ARCH}/tailscale" .

FROM alpine

# Tailscaled depends on iptables (for now)
RUN apk add --no-cache iptables

COPY --from=build /build/tailscale /usr/bin/
COPY --from=build /build/tailscaled /usr/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
