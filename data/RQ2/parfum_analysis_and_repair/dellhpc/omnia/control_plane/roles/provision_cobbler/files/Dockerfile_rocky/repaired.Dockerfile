FROM docker.io/rockylinux/rockylinux:docker_os

# RPM REPOs
RUN dnf install -y \
    epel-release \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN mkdir /root/omnia

RUN dnf install -y mod_ssl \
        python3-librepo \
        python3-schema \
        syslinux \
        wget \
        dhcp-server \
        pykickstart \
        dnf-plugins-core \
        cronie \
        xinetd \
        python3-coverage \
        python3-cheetah \
        python3-netaddr \
        python3-distro \
        python3-devel \
        python3-future \
        python3-mod_wsgi \
        gcc \
        epel-rpm-macros \
        rpm-build \
        ansible \
        make \
        grub2-efi-x64-modules \
        efibootmgr \
        && dnf clean all \
        &&  rm -rf /var/cache/dnf

RUN pip3.8 install netaddr
RUN ansible-galaxy collection install ansible.utils:2.5.2
RUN yum install -y grub2-efi-x64 shim-x64 && rm -rf /var/cache/yum
RUN yum install -y yum-utils && rm -rf /var/cache/yum
RUN dnf config-manager --set-enabled powertools
RUN dnf install -y python3-sphinx
RUN pip3 install --no-cache-dir wheel
RUN dnf module enable -y cobbler:3
RUN dnf install -y cobbler
RUN dnf install -y cobbler-web

#Copy Configuration files
COPY settings.yaml /etc/cobbler/settings.yaml
COPY dhcp.template  /etc/cobbler/dhcp.template
COPY modules.conf  /etc/cobbler/modules.conf
COPY tftp /etc/xinetd.d/tftp
COPY .users.digest /etc/cobbler/users.digest
COPY cobbler_configurations_rocky.yml /root
COPY tftp.yml /root
COPY inventory_creation.yml /root
COPY multi_cluster_provisioning.yml /root

EXPOSE 69 80 443 25151

VOLUME [ "/var/www/cobbler", "/var/lib/cobbler/backup", "/mnt" ]

RUN systemctl enable dhcpd

CMD ["sbin/init"]