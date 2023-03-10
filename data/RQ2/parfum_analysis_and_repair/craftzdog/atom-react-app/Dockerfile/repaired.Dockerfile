# VERSION:        0.1
# DESCRIPTION:    Image to build Atom and create a .rpm file

# Base docker image
FROM nodesource/fedora21:4.2.6

# Install dependencies
RUN yum install -y \
    make \
    gcc \
    gcc-c++ \
    glibc-devel \
    git-core \
    libsecret-devel \
    rpmdevtools && rm -rf /var/cache/yum

RUN npm install -g npm --loglevel error && npm cache clean --force;

ADD . /atom
WORKDIR /atom
