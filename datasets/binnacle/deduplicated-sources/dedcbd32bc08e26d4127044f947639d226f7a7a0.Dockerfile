FROM registry.svc.ci.openshift.org/ocp/4.2:hyperkube

RUN INSTALL_PKGS="conntrack-tools" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all && rm -rf /var/cache/*

COPY ./images/sdn/scripts/iptables /usr/sbin/
COPY ./images/sdn/scripts/iptables-save /usr/sbin/
COPY ./images/sdn/scripts/iptables-restore /usr/sbin/
COPY ./images/sdn/scripts/ip6tables /usr/sbin/
COPY ./images/sdn/scripts/ip6tables-save /usr/sbin/
COPY ./images/sdn/scripts/ip6tables-restore /usr/sbin/
COPY ./images/sdn/scripts/iptables /usr/sbin/

LABEL io.k8s.display-name="Kubernetes kube-proxy" \
      io.k8s.description="Provides kube-proxy for external CNI plugins" \
      io.openshift.tags="openshift,kube-proxy" \
      io.openshift.build.versions="kubernetes=1.14.0"
