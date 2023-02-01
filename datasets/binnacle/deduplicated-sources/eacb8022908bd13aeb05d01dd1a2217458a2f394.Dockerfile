FROM golang:1.9-alpine3.7 as builder

RUN apk --no-cache --update add make git musl-dev

RUN mkdir -p /go/src/github.com/signal18/replication-manager
WORKDIR /go/src/github.com/signal18/replication-manager

COPY . .

RUN make osc cli


FROM alpine:3.7

RUN mkdir -p \
        /etc/replication-manager \
        /var/lib/replication-manager

COPY --from=builder /go/src/github.com/signal18/replication-manager/share /usr/share/replication-manager/
COPY --from=builder /go/src/github.com/signal18/replication-manager/dashboard /usr/share/replication-manager/dashboard
COPY --from=builder /go/src/github.com/signal18/replication-manager/build/binaries/replication-manager-osc /usr/bin/replication-manager
COPY --from=builder /go/src/github.com/signal18/replication-manager/build/binaries/replication-manager-cli /usr/bin/replication-manager-cli

CMD ["replication-manager", "monitor", "--http-server"]
EXPOSE 10001
