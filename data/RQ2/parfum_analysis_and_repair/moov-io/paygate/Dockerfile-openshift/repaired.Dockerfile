FROM quay.io/fedora/fedora:33-x86_64 as builder
RUN yum install -y make golang && rm -rf /var/cache/yum
WORKDIR /opt/app-root/src/
COPY . .
RUN make build

FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG VERSION=unknown
LABEL maintainer="Moov <support@moov.io>"
LABEL name="paygate"
LABEL version=$VERSION

COPY --from=builder /opt/app-root/src/bin/paygate /bin/paygate
ENTRYPOINT ["/bin/paygate"]
