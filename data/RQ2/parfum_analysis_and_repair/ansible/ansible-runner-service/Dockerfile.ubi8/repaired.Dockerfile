# Builder (Donor) image Centos8
FROM docker.io/library/centos:8 as rpm

# Build from UBI8
FROM registry.access.redhat.com/ubi8/ubi:latest

# Ansible Runner Version
ARG ANSIBLE_RUNNER_VERSION="1.4.6"
ARG SERVICE_DIR="/root/ansible-runner-service"

# RPM package list
ARG RPM_PKGS="\
              bash wget unzip nginx supervisor python3-psutil \
              python3-pexpect python3-daemon  bubblewrap gcc \
              bzip2  openssh openssh-clients python2-psutil \
              python3 python3-devel python3-setuptools \
              glibc-locale-source glibc-langpack-en \
"
# Pip package list
ARG PIP_PKGS="\
              ansible cryptography docutils psutil PyYAML \
              pyOpenSSL flask flask-restful uwsgi netaddr notario \
"

# Load CentOS rpm repos 
COPY --from=rpm /etc/pki            /etc/pki
COPY --from=rpm /etc/os-release     /etc/os-release
COPY --from=rpm /etc/yum.repos.d    /etc/yum.repos.d
COPY --from=rpm /etc/redhat-release /etc/redhat-release

# DNF Install Dependencies
RUN set -ex \
     && sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf \
     && dnf update -y -q \
     && dnf install -y -q epel-release \
     && dnf install -y -q ${RPM_PKGS} \
     && dnf clean all \
     && rm -rf /var/cache/yum \
    && echo

# PIP Install Dependencies
RUN set -ex \
     && /usr/bin/python3 -m \
          pip install ${PIP_PKGS} \
     && /usr/bin/python3 -m \
          pip install --no-cache-dir ansible-runner==${ANSIBLE_RUNNER_VERSION} \
    && echo

# Prepare folders for shared access and ssh
RUN set -ex \
     && mkdir -p \
          /root/.ssh \
          /etc/ansible-runner-service \
          /usr/share/ansible-runner-service/{artifacts,env,project,inventory,client_cert} \
     && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && echo

# Install Ansible Runner
WORKDIR /root
COPY ./*.py           ${SERVICE_DIR}/
COPY ./*.yaml         ${SERVICE_DIR}/
COPY ./samples        ${SERVICE_DIR}/samples
COPY ./runner_service ${SERVICE_DIR}/runner_service

# Load configuration files
# Nginx config
COPY misc/nginx/nginx.conf          /etc/nginx/
# Ansible Runner Service nginx virtual server
COPY misc/nginx/ars_site_nginx.conf /etc/nginx/conf.d
# Ansible Runner Service uwsgi settings
COPY misc/nginx/uwsgi.ini           ${SERVICE_DIR}
# Supervisor start sequence