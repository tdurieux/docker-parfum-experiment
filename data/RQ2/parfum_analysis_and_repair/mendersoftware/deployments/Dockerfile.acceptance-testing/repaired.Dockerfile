FROM golang:1.18.3-alpine3.15 as builder
WORKDIR /go/src/github.com/mendersoftware/deployments
COPY ./ .
RUN env CGO_ENABLED=0 go test -c -o deployments -tags main \
    -coverpkg $(go list ./... | grep -v vendor | grep -v mock | grep -v test | tr  '\n' ,)

FROM alpine:3.16.0
RUN apk add --no-cache ca-certificates xz-dev
RUN mkdir /etc/deployments
EXPOSE 8080

COPY ./entrypoint.sh /usr/bin/
COPY  --from=builder /go/src/github.com/mendersoftware/deployments/deployments /usr/bin/deployments
COPY ./config.yaml /usr/bin/

ENV DEPLOYMENTS_MENDER_GATEWAY http://mender-inventory:8080
ENTRYPOINT ["/usr/bin/entrypoint.sh", "server", "--automigrate"]

STOPSIGNAL SIGINT