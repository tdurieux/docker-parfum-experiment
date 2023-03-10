FROM fedora:24

# Install Ansible
RUN dnf -y update; dnf clean all;
# RUN dnf -y install epel-release
RUN dnf -y install python-dnf git ansible sudo
RUN dnf -y install python-pip
RUN pip install --no-cache-dir avisdk
RUN dnf clean all

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/usr/sbin/init"]
