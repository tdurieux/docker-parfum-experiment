#
# VIP failover monitoring container for OpenShift Origin.
#
# ImageName: openshift/origin-keepalived-ipfailover
#
FROM openshift/origin-base

RUN INSTALL_PKGS="kmod keepalived iproute psmisc nmap-ncat net-tools" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

ADD conf/ /var/lib/openshift/ipfailover/keepalived/conf/
ADD lib/  /var/lib/openshift/ipfailover/keepalived/lib/
ADD bin/  /var/lib/openshift/ipfailover/keepalived/bin/
ADD monitor.sh /var/lib/openshift/ipfailover/keepalived/

EXPOSE 1985
ENTRYPOINT ["/var/lib/openshift/ipfailover/keepalived/monitor.sh"]
