FROM centos
MAINTAINER aophir@rmn.com

RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm && \
    yum install -y \
    vim-enhanced \
    mlocate \
    git \
    gcc \
    python-pip \
    python-devel \ 
    postgres-devel \
    postgres-contrib \
    libpqxx-devel \
    npm && rm -rf /var/cache/yum

RUN yum install -y \
    libxml2-devel \
    xmlsec1-devel \
    xmlsec1-openssl-devel \
    libtool-ltdl-devel \
    libxml2 \
    libxslt && rm -rf /var/cache/yum

Run pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir email

#  The config file used to launch a local run
ADD ./dart-local.yaml /root

# preparing to run the webserver using the same env variables as above
ENV AWS_SECRET_ACCESS_KEY=not_needed_locally  \
    AWS_SECRET_ACCESS_KEY=not_needed_locally  \
    DART_ROLE={{ container_dart_role }}  \
    DART_CONFIG=/root/dart-local.yaml  \ 
    PYTHONPATH={{ docker_code_dir }}/src/python

{{ export_port }}

ADD ./docker_CMD.sh /root
RUN chmod +x /root/docker_CMD.sh

WORKDIR /root
CMD ./docker_CMD.sh
