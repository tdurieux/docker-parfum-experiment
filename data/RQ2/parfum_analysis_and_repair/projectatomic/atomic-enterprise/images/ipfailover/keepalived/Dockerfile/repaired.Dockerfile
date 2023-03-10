#
# VIP failover monitoring container for OpenShift Origin.
#
# ImageName: openshift/origin-keepalived-ipfailover
#
FROM openshift/origin-base

RUN yum -y install kmod keepalived iproute psmisc nc net-tools && \
    yum clean all && rm -rf /var/cache/yum

ADD conf/ /var/lib/openshift/ipfailover/keepalived/conf/
ADD lib/  /var/lib/openshift/ipfailover/keepalived/lib/
ADD bin/  /var/lib/openshift/ipfailover/keepalived/bin/
ADD monitor.sh /var/lib/openshift/ipfailover/keepalived/

EXPOSE 1985
ENTRYPOINT ["/var/lib/openshift/ipfailover/keepalived/monitor.sh"]
