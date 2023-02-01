FROM ubuntu:18.04
USER root

# golang general
RUN apt-get update && apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;
VOLUME /opt/gopath
WORKDIR /opt/gopath
ENV GOPATH /opt/gopath

# kvmtop specific
RUN apt-get install --no-install-recommends -y libvirt-dev pkg-config libncurses5-dev && rm -rf /var/lib/apt/lists/*;
CMD go build github.com/cha87de/kvmtop/cmd/kvmtop