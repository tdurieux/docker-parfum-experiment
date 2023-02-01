# Dockerfile
ARG image
FROM $image
# Install Ansible
RUN apt-get update
ARG additional_packages
RUN apt-get install --no-install-recommends -y software-properties-common git gnupg && rm -rf /var/lib/apt/lists/*;
RUN echo apt-get install -y wget $additional_packages
RUN apt-get install --no-install-recommends -y wget $additional_packages && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update
RUN apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;
# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN echo "retry_files_enabled = False" >> /etc/ansible/ansible.cfg