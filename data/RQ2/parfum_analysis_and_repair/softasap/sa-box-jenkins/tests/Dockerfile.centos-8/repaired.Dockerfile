FROM centos:8

ENV container docker

RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm

# Install Ansible
RUN yum -y install sudo python3-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -U ansible ansible-lint
RUN mkdir -p /etc/ansible

# Install Ansible inventory file
RUN echo "[local]" > /etc/ansible/hosts
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts
