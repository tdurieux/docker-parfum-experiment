FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target

# everything else below is to setup maas into the systemd initialized
# container based on ubuntu 16.04
RUN apt-get -qq update && \
    apt-get -y --no-install-recommends install sudo software-properties-common && rm -rf /var/lib/apt/lists/*;

# TODO(alanmeadows)
# we need systemd 231 per https://github.com/systemd/systemd/commit/a1350640ba605cf5876b25abfee886488a33e50b
RUN add-apt-repository ppa:pitti/systemd -y && add-apt-repository ppa:maas/stable -y && apt-get update
RUN apt-get install --no-install-recommends -y systemd && rm -rf /var/lib/apt/lists/*;

# install syslog and enable it
RUN apt-get install --no-install-recommends -y rsyslog && rm -rf /var/lib/apt/lists/*;
RUN systemctl enable rsyslog.service

# install maas
RUN rsyslogd; apt-get install --no-install-recommends -y maas-cli \
    maas-dns \
    maas-region-api \
    avahi-utils \
    dbconfig-pgsql=2.0.4ubuntu1 \
    iputils-ping \
    postgresql \
    tcpdump \
    python3-pip && rm -rf /var/lib/apt/lists/*;


RUN apt-get download maas-region-controller && \
# remove postinstall script in order to avoid db_sync
    dpkg-deb --extract maas-region-controller*.deb maas-region-controller && \
    dpkg-deb --control maas-region-controller*.deb maas-region-controller/DEBIAN && \
    rm maas-region-controller/DEBIAN/postinst && \
    dpkg-deb --build maas-region-controller && \
    dpkg -i maas-region-controller.deb && \
    pg_dropcluster --stop 9.5 main

# potentially used to calculate cidrs
RUN pip3 install --no-cache-dir netaddr

# initalize systemd
CMD ["/sbin/init"]
