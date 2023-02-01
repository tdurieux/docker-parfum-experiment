# Dockerfile to create a go-getter container with smbclient dependency that is used by the get_smb.go tests
FROM golang:1.15

COPY . /go-getter
WORKDIR /go-getter

RUN go mod download
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install smbclient && rm -rf /var/lib/apt/lists/*;
