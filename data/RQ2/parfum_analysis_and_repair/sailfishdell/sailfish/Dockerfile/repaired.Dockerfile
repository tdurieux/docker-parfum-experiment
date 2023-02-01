#FROM  pgre-artifactory.pgre.dell.com:8001/golang:latest AS builder
FROM  golang:latest AS builder

# copy source tree in
COPY . /build/

# create a self-contained build structure