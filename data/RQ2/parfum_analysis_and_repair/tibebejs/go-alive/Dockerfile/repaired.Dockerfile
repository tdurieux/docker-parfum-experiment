FROM golang:1.16.2-alpine AS builder
ADD . /src
WORKDIR /src
RUN --mount=type=cache,mode=0755,target=/go/pkg/mod go get -d -v
RUN apk add --no-cache ca-certificates
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/go-alive -a -ldflags '-s -w' /src

FROM scratch
LABEL MAINTAINER="Tibebeselasie Mehari <Tibebes.js@gmail.com>"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /bin/go-alive /bin/go-alive

VOLUME /config
ENTRYPOINT ["/bin/go-alive"]