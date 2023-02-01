FROM centos:8

ARG HTTP_PROXY=${HTTP_PROXY}
ARG HTTPS_PROXY=${HTTPS_PROXY}

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY
ENV no_proxy $NO_PROXY

RUN yum update -y && yum install -y -qq make curl net-tools iproute iptables \
    wget nc jq ipset unbound unbound-devel && rm -rf /var/cache/yum

RUN mkdir -p /opt/ovn4nfv-k8s-plugin/ovs/rpm/rpmbuild/RPMS/x86_64
RUN bash -xc "\
pushd /opt/ovn4nfv-k8s-plugin/ovs/rpm/rpmbuild/RPMS/x86_64; \
wget -q -nv -O- https://api.github.com/repos/akraino-icn/ovs/releases/tags/v2.14.0 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains("\""rpm"\"")) | .browser_download_url' | wget -i -; \
popd; \
"
RUN rpm -ivh --nodeps /opt/ovn4nfv-k8s-plugin/ovs/rpm/rpmbuild/RPMS/x86_64/*.rpm

RUN mkdir -p /opt/ovn4nfv-k8s-plugin/ovn/rpm/rpmbuild/RPMS/x86_64
RUN bash -xc "\
pushd /opt/ovn4nfv-k8s-plugin/ovn/rpm/rpmbuild/RPMS/x86_64; \
wget -q -nv -O- https://api.github.com/repos/akraino-icn/ovn/releases/tags/v20.06.0 2>/dev/null | jq -r '.assets[] | select(.browser_download_url | contains("\""rpm"\"")) | .browser_download_url' | wget -i -; \
popd; \
"
RUN rpm -ivh --nodeps /opt/ovn4nfv-k8s-plugin/ovn/rpm/rpmbuild/RPMS/x86_64/*.rpm

ENV GOLANG_VERSION 1.14.1
RUN curl -f -sSL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz \
        | tar -v -C /usr/local -xz

ENV PATH /usr/local/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

WORKDIR /go/src/github.com/opnfv/ovn4nfv-k8s-plugin
COPY . .
RUN make all

ENV OPERATOR=/usr/local/bin/nfn-operator \
    AGENT=/usr/local/bin/nfn-agent \
    USER_UID=1001 \
    USER_NAME=nfn-operator

RUN cp -r build/bin/* /usr/local/bin/
ENTRYPOINT ["entrypoint"]
