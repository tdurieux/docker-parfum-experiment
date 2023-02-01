ARG BASE_IMAGE=alpine:3.16

FROM golang:1.18.3-alpine3.16 as builder

ARG GOPROXY
ARG GOTAGS
ARG GOGCFLAGS

WORKDIR /go/src/d7y.io/dragonfly/v2

RUN apk --no-cache add bash make gcc libc-dev git

COPY . /go/src/d7y.io/dragonfly/v2

RUN make build-scheduler && make install-scheduler

FROM ${BASE_IMAGE} as health

ENV GRPC_HEALTH_PROBE_VERSION v0.4.11

RUN wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

FROM ${BASE_IMAGE}

ENV PATH=/opt/dragonfly/bin:$PATH
RUN echo "hosts: files dns" > /etc/nsswitch.conf

COPY --from=builder /opt/dragonfly/bin/scheduler /opt/dragonfly/bin/scheduler
COPY --from=health /bin/grpc_health_probe /bin/grpc_health_probe

EXPOSE 8002

ENTRYPOINT ["/opt/dragonfly/bin/scheduler"]