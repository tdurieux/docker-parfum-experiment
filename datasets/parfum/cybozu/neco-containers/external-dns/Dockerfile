# ExternalDNS container image

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG EXTERNALDNS_VERSION=0.11.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSLf https://github.com/kubernetes-sigs/external-dns/archive/v${EXTERNALDNS_VERSION}.tar.gz | \
        tar zxf - -C /work/ \
    && mv external-dns-${EXTERNALDNS_VERSION} /work/external-dns

WORKDIR /work/external-dns/

RUN make build

# Stage2: setup runtime container
FROM quay.io/cybozu/ubuntu:20.04

COPY --from=build /work/external-dns/build/external-dns /usr/local/external-dns/bin/external-dns
COPY --from=build /work/external-dns/LICENSE  /usr/local/external-dns/LICENSE
ENV PATH=/usr/local/external-dns/bin:"$PATH"

USER 10000:10000

ENTRYPOINT ["external-dns"]
