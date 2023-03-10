FROM ubuntu:12.04
RUN apt-get update

# Install Ansible
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties git && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
