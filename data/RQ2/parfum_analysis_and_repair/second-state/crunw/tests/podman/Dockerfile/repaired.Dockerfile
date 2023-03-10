FROM fedora:latest

ENV GOPATH=/root/go
ENV PATH=/usr/bin:/usr/sbin:/root/go/bin:/usr/local/bin::/usr/local/sbin

RUN yum install -y golang python git gcc automake autoconf libcap-devel \
    systemd-devel yajl-devel libseccomp-devel go-md2man \
    glibc-static python3-libmount libtool make podman xz nmap-ncat && \
    dnf install -y 'dnf-command(builddep)' && dnf builddep -y podman && \
    go get github.com/onsi/ginkgo/ginkgo && \
    go get github.com/onsi/gomega/... && \
    mkdir -p /root/go/src/github.com/containers && \
    chmod 755 /root && \
    (cd /root/go/src/github.com/containers && git clone -b v3.0.0 https://github.com/containers/podman && \
     cd podman && \
     make install.catatonit && \
     make) && rm -rf /var/cache/yum

COPY run-tests.sh /usr/local/bin

ENTRYPOINT /usr/local/bin/run-tests.sh /root/go/src/github.com/containers/podman
