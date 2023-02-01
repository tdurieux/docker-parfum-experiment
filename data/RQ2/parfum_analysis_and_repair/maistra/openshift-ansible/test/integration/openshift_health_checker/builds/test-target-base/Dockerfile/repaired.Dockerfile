FROM centos/systemd
RUN yum install -y iproute python-dbus PyYAML yum-utils && rm -rf /var/cache/yum
