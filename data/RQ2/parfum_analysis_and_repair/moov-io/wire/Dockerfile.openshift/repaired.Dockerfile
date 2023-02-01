FROM registry.access.redhat.com/ubi8/go-toolset as builder
COPY . .
RUN make build

FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG VERSION=unknown
LABEL maintainer="Moov <support@moov.io>"
LABEL name="wire"
LABEL version=$VERSION

COPY --from=builder /opt/app-root/src/bin/server /bin/server

ENTRYPOINT ["/bin/server"]