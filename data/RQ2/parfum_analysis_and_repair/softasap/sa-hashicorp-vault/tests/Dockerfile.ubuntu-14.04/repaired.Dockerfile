FROM ubuntu:14.04

ENV container docker

RUN apt-get update

# Install Ansible
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y software-properties-common curl git python-dev wget apt-transport-https libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir ansible ansible-lint
RUN mkdir -p /etc/ansible

# setup tools 3.3 conflict
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python

#COPY initctl_faker .
#RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
