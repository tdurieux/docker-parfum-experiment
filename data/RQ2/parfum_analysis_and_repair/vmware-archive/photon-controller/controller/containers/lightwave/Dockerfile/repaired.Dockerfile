FROM esxcloud/servicebase

ENV container=docker
VOLUME ["/sys/fs/cgroup"]

# install systemd
RUN tdnf makecache; \
    tdnf update -y tdnf; \
    tdnf update -y rpm; \
    tdnf install -y systemd; \
    # Remove unused systemd services
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service;\
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    mkdir -p /var/run/sshd; chmod -rx /var/run/sshd; \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key; \
    # configure journald
    sed -i 's/#Storage=auto/Storage=persistent/' /etc/systemd/journald.conf; \
    tdnf install -y procps-ng; \
    tdnf install -y commons-daemon \
                    apache-tomcat \
                    boost-1.56.0; \
    tdnf install -y likewise-open-6.2.9; \
    tdnf install -y vmware-lightwave-server-6.6.2; \
    rm -rf /usr/share/doc/*; \
    rm -rf /usr/share/man/*; \
    rm -rf /usr/include/*;

ADD configure-lightwave-server.service /usr/lib/systemd/system/
RUN ln -s /usr/lib/systemd/system/configure-lightwave-server.service \
          /etc/systemd/system/multi-user.target.wants/configure-lightwave-server.service

EXPOSE 22 53/udp 53 88/udp 88 389 636 2012 2014 2020

ENTRYPOINT ["/usr/sbin/init"]