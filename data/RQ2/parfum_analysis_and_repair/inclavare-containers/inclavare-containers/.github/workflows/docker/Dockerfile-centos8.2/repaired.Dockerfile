FROM inclavarecontainers/test:crictl-bin-centos8.2 AS crictl-src

FROM occlum/occlum:OCCLUM_VERSION-centos8.2

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

RUN yum install -y libseccomp-devel iptables openssl openssl-devel wget make && rm -rf /var/cache/yum

RUN dnf --enablerepo=PowerTools install -y binutils-devel protobuf-devel protobuf-c-devel glibc-static

WORKDIR /root

RUN mkdir -p /usr/local/go                                  \
    /etc/containerd                                         \
    /etc/cni/net.d                                          \
    /opt/cni                                                \
    /root/samples                                           \
    /tmp/hello_world

# copy binary and configure files
COPY --from=crictl-src /opt/cni                             /opt/cni
COPY --from=crictl-src /etc/containerd/config.toml          /etc/containerd
COPY --from=crictl-src /usr/local/bin                       /usr/local/bin

COPY 10-mynet.conf                                          /etc/cni/net.d
COPY 99-loopback.conf                                       /etc/cni/net.d
COPY crictl.yaml                                            /etc
COPY samples                                                /root/samples
COPY Dockerfile-occlum                                      /root
COPY Dockerfile-skeleton                                    /root
COPY hello_world.c                                          /root

# install docker-ce
RUN yum install -y yum-utils device-mapper-persistent-data lvm2 && \
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && \
    yum makecache && yum -y install docker-ce && rm -rf /var/cache/yum

# configure docker
RUN mkdir -p /etc/docker && \
    echo -e "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t}\n}" >> /etc/docker/daemon.json

# install go
RUN wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
    tar -zxvf go1.14.2.linux-amd64.tar.gz -C /usr/lib && rm go1.14.2.linux-amd64.tar.gz

ENV GOROOT          /usr/lib/go
ENV GOPATH          /root/gopath
ENV PATH            $GOROOT/bin:$PATH:$GOPATH/bin
ENV GOPROXY         "https://mirrors.aliyun.com/goproxy,direct"
ENV GO111MODULE     on
