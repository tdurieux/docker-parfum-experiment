FROM quay.io/pypa/manylinux2014_x86_64
RUN yum install -y systemd-devel && rm -rf /var/cache/yum
