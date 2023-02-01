FROM centos:7

RUN yum install -y epel-release && rm -rf /var/cache/yum

RUN yum install -y bzip2 \
    gcc-c++ \
    gettext \
    git \
    make \
    python \
    python-pip && rm -rf /var/cache/yum

RUN curl -f --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum
RUN npm set progress=false

WORKDIR "/awx"

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["make sdist"]
