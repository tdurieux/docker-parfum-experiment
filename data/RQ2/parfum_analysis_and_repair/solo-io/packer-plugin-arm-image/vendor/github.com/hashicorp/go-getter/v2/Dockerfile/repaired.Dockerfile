# Dockerfile to create a go-getter container with smbclient dependency that is used by the get_smb.go tests
FROM golang:latest

COPY . /go-getter
WORKDIR /go-getter

RUN go mod download
RUN apt-get update && apt-get -y --no-install-recommends install smbclient && rm -rf /var/lib/apt/lists/*;
