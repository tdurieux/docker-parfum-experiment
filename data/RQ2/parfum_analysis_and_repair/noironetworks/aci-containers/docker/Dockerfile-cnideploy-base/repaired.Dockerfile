ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
RUN yum install -y wget ca-certificates tar gzip \
  && yum clean all \
  && mkdir -p /opt/cni/bin && wget -O- https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-amd64-v0.9.1.tgz | tar xz -C /opt/cni/bin && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
