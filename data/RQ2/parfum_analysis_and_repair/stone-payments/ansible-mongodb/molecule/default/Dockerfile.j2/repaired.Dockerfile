# Molecule managed

FROM {{ item.image }}

ENV container=docker

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python sudo bash ca-certificates systemd iproute && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ];then dnf makecache && dnf --assumeyes install python python-devel python2-dnf bash systemd iproute && dnf clean all; \
    elif [ $(command -v yum) ]; then \
    yum makecache fast && yum update -y && yum install -y python sudo yum-plugin-ovl bash systemd iproute && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; rm -rf /var/cache/yumfi

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
