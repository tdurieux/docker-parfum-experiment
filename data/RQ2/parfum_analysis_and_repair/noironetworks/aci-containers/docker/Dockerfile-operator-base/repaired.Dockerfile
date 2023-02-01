ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
RUN yum install -y git \
  && yum clean all \
  && curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.3/bin/linux/amd64/kubectl \
  && chmod u+x kubectl && mv kubectl /usr/local/bin/kubectl && rm -rf /var/cache/yum
CMD ["/usr/bin/sh"]
