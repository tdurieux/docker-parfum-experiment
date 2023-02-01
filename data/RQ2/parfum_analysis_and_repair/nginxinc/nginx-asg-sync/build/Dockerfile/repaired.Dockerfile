ARG CONTAINER_VERSION=amazonlinux:2
ARG OS_TYPE=deb_based

FROM golang:1.18-alpine AS builder
WORKDIR /go/src/github.com/nginxinc/nginx-asg-sync/cmd/sync
COPY go.mod go.sum /go/src/github.com/nginxinc/nginx-asg-sync/
RUN go mod download
COPY . /go/src/github.com/nginxinc/nginx-asg-sync/

RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o /nginx-asg-sync

#---------------------------------------------------------------------------------------------

FROM ${CONTAINER_VERSION} as rpm_based

RUN yum install -y rpmdevtools && rm -rf /var/cache/yum
ADD build/package/builders/rpm_based/build.sh /

ENTRYPOINT ["/build.sh"]

#---------------------------------------------------------------------------------------------

FROM debian:buster as deb_based

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install build-essential debhelper-compat -y && rm -rf /var/lib/apt/lists/*;
ADD build/package/builders/deb_based/build.sh /

ENTRYPOINT ["/build.sh"]

#---------------------------------------------------------------------------------------------

FROM ${OS_TYPE} as container

COPY --from=builder /nginx-asg-sync /nginx-asg-sync


#---------------------------------------------------------------------------------------------

FROM ${OS_TYPE} as local

COPY nginx-asg-sync /nginx-asg-sync
