FROM centos
MAINTAINER aophir@rmn.com

RUN yum install epel-release -y && rm -rf /var/cache/yum
RUN yum install -y \
    vim-enhanced \
    mlocate \
    git \
    python-pip \
    python-devel \
    postgres-devel \
    postgres-contrib \
    libpqxx-devel \
    npm && rm -rf /var/cache/yum

Run pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir email

#  The config file used to launch a local run
ADD ./dart-local.yaml /root

# preparing to run the webserver using the same env variables as above
ENV AWS_SECRET_ACCESS_KEY=not_needed_locally  \
    AWS_SECRET_ACCESS_KEY=not_needed_locally  \
    DART_ROLE=worker  \
    DART_CONFIG=/root/dart-local.yaml  \ 
    PYTHONPATH=/tmp/src/python



ADD ./docker_CMD.sh /root
RUN chmod +x /root/docker_CMD.sh

WORKDIR /root
CMD ./docker_CMD.sh