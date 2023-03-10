FROM ubuntu:12.04
RUN apt-get update

# Install Ansible
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common python-software-properties git
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends -y ansible && rm -rf /var/lib/apt/lists/*;

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
