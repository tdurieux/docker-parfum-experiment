FROM ubuntu:18.04
RUN apt-get update

# Install Ansible
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common git systemd
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install --no-install-recommends -y python sudo python-pip python-dev libffi-dev ansible && rm -rf /var/lib/apt/lists/*;

# Install Ansible inventory file
#RUN mkdir /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
