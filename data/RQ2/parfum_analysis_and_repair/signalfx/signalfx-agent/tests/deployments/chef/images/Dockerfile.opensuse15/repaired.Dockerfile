FROM opensuse/leap:15

ENV container docker

RUN zypper -n install -l curl dbus-1 gzip hostname systemd-sysvinit tar wget

ARG CHEF_INSTALLER_ARGS
RUN echo -e 'Enterprise\nVERSION = 15' > /etc/SuSE-release && \
    curl -f -L https://omnitruck.chef.io/install.sh | bash -s -- $CHEF_INSTALLER_ARGS

WORKDIR /opt/cookbooks
RUN curl -f -Lo windows.tar.gz https://supermarket.chef.io/cookbooks/windows/versions/4.3.4/download && \
    tar -xzf windows.tar.gz && rm windows.tar.gz

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*;

COPY tests/packaging/images/socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY tests/packaging/images/certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/ssl/certs/ca-bundle.crt

COPY deployments/chef /opt/cookbooks/signalfx_agent

WORKDIR /opt

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/sbin/init"]
