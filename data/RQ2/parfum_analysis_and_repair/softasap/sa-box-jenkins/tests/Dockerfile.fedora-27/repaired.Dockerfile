FROM fedora:27

ENV container docker

RUN dnf -y update && dnf install -y findutils && dnf -y install dnf-plugins-core

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target

COPY setup /sbin/

STOPSIGNAL SIGRTMIN+3

# Install Ansible
RUN dnf -y update
RUN dnf install -y python3 python3-pip python3-dnf libselinux-python3 sudo
RUN pip3 install --no-cache-dir -U ansible==2.9.6
RUN pip3 install --no-cache-dir -U ansible-lint
RUN mkdir -p /etc/ansible

RUN dnf -y groupinstall "Development Tools"

# Install Ansible inventory file
RUN echo "[local]" > /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts
