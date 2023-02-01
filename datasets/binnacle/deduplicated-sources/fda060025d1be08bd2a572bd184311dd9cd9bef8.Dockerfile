FROM debian:9
RUN apt-get update

# Install Ansible
RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common git
RUN apt-get update
RUN apt-get install -y python sudo python-pip python-dev libffi-dev
RUN pip install --upgrade setuptools

RUN mkdir -p /etc/ansible
# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN echo "[defaults]\ncallback_whitelist = profile_tasks, timer" > /etc/ansible/ansible.cfg
