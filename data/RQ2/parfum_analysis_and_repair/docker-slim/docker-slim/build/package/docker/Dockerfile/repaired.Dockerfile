FROM alpine:latest as ca-certs
LABEL build-role=ca-certs
RUN apk update && apk upgrade && apk add --no-cache ca-certificates && update-ca-certificates 2>/dev/null || true

FROM scratch
LABEL app=docker-slim
COPY --from=ca-certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY dist_linux /bin
COPY build/package/docker/.ds.container.d3e2c84f976743bdb92a7044ef12e381 /.ds.container.d3e2c84f976743bdb92a7044ef12e381
VOLUME /bin/.docker-slim-state
ENTRYPOINT ["/bin/docker-slim"]