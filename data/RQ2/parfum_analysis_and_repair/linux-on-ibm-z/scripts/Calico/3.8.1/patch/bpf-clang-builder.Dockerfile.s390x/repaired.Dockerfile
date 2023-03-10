FROM s390x/debian:buster-slim
ENV GOPATH /go
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --no-install-recommends \
    llvm clang linux-headers-s390x make binutils git file iproute2 golang-go ca-certificates && \
apt-get purge --auto-remove && \
apt-get clean && \
mkdir -p /src /go && \
go get -u github.com/gobuffalo/packr/v2/packr2 && \
rm -rf /go/src && rm -rf /var/lib/apt/lists/*;
