FROM fedora:28

ENV container docker

RUN dnf -y update && dnf install -y findutils

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
RUN dnf install -y python2 python2-dnf python-pip libselinux-python sudo
RUN pip install --no-cache-dir -U ansible==2.5.2
RUN mkdir -p /etc/ansible

# Install Ansible inventory file
RUN echo "[local]" > /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts
