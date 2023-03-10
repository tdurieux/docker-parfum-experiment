FROM vpp-container-fun/base
MAINTAINER mestery@mestery.com

COPY startstrongswan.sh /
COPY startvpp.sh /
COPY startup.conf /etc/vpp/startup.conf

RUN yum -y install epel-release && \
    yum -y install strongswan tcpdump && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT /startvpp.sh