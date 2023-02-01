FROM golang:1.12-alpine

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on

RUN  \
     apk add --no-cache git && \
     git clone https://github.com/minio/minio && cd minio/dockerscripts && \
     go build -tags kqueue -ldflags "-s -w" -o /usr/bin/healthcheck healthcheck.go && \
     go build -tags kqueue -ldflags "-s -w" -o /usr/bin/check-user check-user.go

FROM alpine:3.9

LABEL maintainer="MinIO Inc <dev@min.io>"

COPY --from=0 /usr/bin/healthcheck /usr/bin/healthcheck
COPY --from=0 /usr/bin/check-user /usr/bin/check-user
COPY dockerscripts/docker-entrypoint.sh /usr/bin/

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

RUN \
     apk add --no-cache ca-certificates 'curl>7.61.0' 'su-exec>=0.2' && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     curl https://dl.min.io/server/minio/release/linux-amd64/minio > /usr/bin/minio && \
     chmod +x /usr/bin/minio  && \
     chmod +x /usr/bin/docker-entrypoint.sh && \
     chmod +x /usr/bin/healthcheck && \
     chmod +x /usr/bin/check-user

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

HEALTHCHECK --interval=1m CMD healthcheck

CMD ["minio"]
