#upstream https://github.com/cloudflare/ebpf_exporter
FROM golang:1.10.3-stretch

# Doing mostly what CI is doing here
RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648A4A16A23015EEF4A66B8E4052245BD4284CDD && \
    echo "deb https://repo.iovisor.org/apt/xenial xenial main" > /etc/apt/sources.list.d/iovisor.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y libbcc=0.6.1-1 linux-headers-amd64 && rm -rf /var/lib/apt/lists/*;

ENV GO_PACKAGE=github.com/cloudflare/ebpf_exporter

COPY ./ /go/src/$GO_PACKAGE

RUN go install -v $GO_PACKAGE/cmd/...
