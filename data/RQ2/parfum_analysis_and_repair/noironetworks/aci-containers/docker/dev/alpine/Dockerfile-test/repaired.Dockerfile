FROM registry.access.redhat.com/ubi8/ubi:latest
RUN yum --disablerepo=\*ubi\* update -y && \
  yum --disablerepo=\*ubi\* install -y iproute nftables \
  && yum clean all && rm -rf /var/cache/yum
COPY dist-static/aci-containers-host-agent dist-static/opflex-agent-cni docker/launch-hostagent.sh docker/enable-hostacc.sh docker/enable-droplog.sh /usr/local/bin/
ENV TENANT=kube
ENV NODE_EPG='kubernetes|kube-nodes'
CMD ["/usr/local/bin/launch-hostagent.sh"]
