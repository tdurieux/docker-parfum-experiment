FROM s390x/debian:9.8-slim

LABEL maintainer "LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"

ADD bin/s390x/ /opt/cni/bin/
ADD k8s-install/scripts/install-cni.sh /install-cni.sh
ADD k8s-install/scripts/calico.conf.default /calico.conf.tmp

ENV PATH=$PATH:/opt/cni/bin
WORKDIR /opt/cni/bin
CMD ["/opt/cni/bin/calico"]
