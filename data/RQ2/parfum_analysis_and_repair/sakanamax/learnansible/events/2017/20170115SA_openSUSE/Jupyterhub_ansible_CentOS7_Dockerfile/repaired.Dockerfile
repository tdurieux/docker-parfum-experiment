# Jupyterhub / Ansible on Centos 7.0
FROM centos:7.2.1511
# Author
MAINTAINER Fei Yeh <fyeh@icair.org>, Max Huang <sakana@cycu.org.tw>

#
# 20160514
# - from centos 7.2.1511
# - fix paramiko install problem, use python-paramiko instead
# - fix jupyterhub, add --no-ssl 

# Install Enterprise Repository
RUN \
  yum install epel-release -y && rm -rf /var/cache/yum

# Install Python and pre-requisite packages
RUN \
  yum install -y \
   passwd \
   python-devel \
   python34 \
   python34-devel \
   zlib-devel \
   bzip2-devel \
   openssl-devel \
   ncurses-devel \
   sqlite-devel \
   readline-devel \
   tk-devel \
   gdbm-devel \
   db4-devel \
   libpcap-devel \
   xz-devel \
   npm \
   wget \
   unzip && rm -rf /var/cache/yum

# run npm configurable-http-proxy
RUN npm install -g configurable-http-proxy && npm cache clean --force;

# Get pip 3
RUN wget https://bootstrap.pypa.io/get-pip.py

# Install pip3
RUN python3.4 get-pip.py

# Install Jupyterhub
RUN pip3 install --no-cache-dir jupyterhub ipython[notebook]

# Install python-paramiko
RUN yum -y install python-paramiko && rm -rf /var/cache/yum

# Install Ansible
RUN yum -y install ansible && rm -rf /var/cache/yum

#expose ports
EXPOSE 8000

# create user
RUN useradd -m ansible && echo "ansible:2016StudyArea"|chpasswd

# Get playbook
RUN wget https://github.com/sakanamax/LearnJupyter/archive/master.zip -O /home/ansible/master.zip
RUN su - ansible -c "unzip master.zip"


# Define default command.
CMD ["jupyterhub", "--no-ssl"]
