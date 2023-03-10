FROM centos:6

# Install Ansible
RUN yum -y update; yum clean all;
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install git python-setuptools gcc sudo libffi-devel python-devel openssl-devel && rm -rf /var/cache/yum
RUN yum clean all
RUN easy_install pip
RUN pip install --no-cache-dir ansible


# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file
RUN mkdir - p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/usr/sbin/init"]
