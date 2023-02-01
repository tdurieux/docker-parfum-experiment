# testhttpd container

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build
COPY src /work/src
WORKDIR /work/src
RUN CGO_ENABLED=0 go install -ldflags="-w -s" ./testhttpd

# Stage2: setup runtime container