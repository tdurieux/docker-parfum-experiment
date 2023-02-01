FROM golang:1.17.1-alpine3.14 as builder

WORKDIR /app
COPY curielogger .
RUN go build -o build/curielogger ./cmd/grpc

FROM alpine:3
RUN apk update && apk add ca-certificates curl bash apache2-utils && rm -rf /var/cache/apk/*
RUN mkdir -p /etc/curielogger/
COPY contrib /contrib
COPY --from=builder /app/build/curielogger /bin
COPY --from=builder /app/curielogger.yml /etc/curielogger/
ENTRYPOINT ["/bin/curielogger"]
