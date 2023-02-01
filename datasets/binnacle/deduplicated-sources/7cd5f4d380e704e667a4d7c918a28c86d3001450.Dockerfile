FROM centos:6
#RUN yum update

# Install OpenSSH server
RUN yum install -y openssh-server epel-release libffi-devel gcc

# Install Ansible
RUN yum install -y python-pip python-devel openssl-devel
#software-properties-common git  python-dev libffi-dev libssl-dev
RUN pip install --upgrade pip
RUN pip install -U setuptools
RUN pip install 'ansible==2.3.0.0'

# Install Ansible inventory file
RUN mkdir /etc/ansible/ && echo "localhost ansible_connection=local" > /etc/ansible/hosts
