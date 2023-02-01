FROM ubuntu:latest AS build
ARG VERSION
RUN mkdir -p /build \
 && apt-get update \
 && apt-get install --no-install-recommends -y curl \
 && echo "retrieving kube-proxy v${VERSION}..." \
 && curl -f -Lo /build/kube-proxy https://storage.googleapis.com/kubernetes-release/release/v${VERSION}/bin/linux/amd64/kube-proxy \
 && chmod 755 /build/* && rm -rf /var/lib/apt/lists/*;

FROM alpine:latest
MAINTAINER James Hunt <james@niftylogic.com>
RUN apk add --no-cache iptables ipset ipvsadm conntrack-tools
COPY --from=build /build/ /
