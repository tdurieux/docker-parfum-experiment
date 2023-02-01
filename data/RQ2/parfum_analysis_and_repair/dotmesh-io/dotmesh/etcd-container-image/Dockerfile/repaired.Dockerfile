FROM quay.io/coreos/etcd:v3.4.0
RUN apk update && apk add --no-cache ca-certificates
