FROM registry.centos.org/centos:8
USER root
RUN dnf install -y --nodocs python3 python3-pip python3-devel numactl-devel perl \
    epel-release procps-ng iproute net-tools ethtool nmap iputils gcc
RUN dnf -y install https://www.rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/rt-tests-1.10-3.el8.x86_64.rpm
RUN dnf -y --enablerepo=extras install --nodocs wget tmux stress-ng \
    https://cbs.centos.org/kojifiles/packages/dumb-init/1.2.2/6.el8/x86_64/dumb-init-1.2.2-6.el8.x86_64.rpm \
    && dnf clean all && rm -rf /var/cache/yum
COPY . /opt/snafu
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -e /opt/snafu/
RUN ln -s /usr/bin/python3 /usr/bin/python
