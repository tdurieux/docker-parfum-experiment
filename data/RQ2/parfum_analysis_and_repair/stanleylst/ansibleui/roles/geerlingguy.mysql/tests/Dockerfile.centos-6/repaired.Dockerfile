FROM centos:6

RUN yum -y install redhat-lsb-core && rm -rf /var/cache/yum

# Install Ansible
RUN yum -y update; yum clean all;
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install git ansible sudo && rm -rf /var/cache/yum
RUN yum clean all

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/usr/sbin/init"]
