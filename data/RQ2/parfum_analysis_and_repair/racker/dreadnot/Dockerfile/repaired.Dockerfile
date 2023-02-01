FROM node:4
MAINTAINER Rackspace Monitoring ele-dev@lists.rackspace.com

# container image updates
RUN apt-get update -y --fix-missing && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y make git-core wget && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;

ADD . /opt/dreadnot

WORKDIR /opt/dreadnot

# make
RUN npm install && npm cache clean --force;

EXPOSE 8080

ENTRYPOINT ["/opt/dn/bin/dreadnot", "-p 8080", "-c /etc/dreadnot.js", "-s /opt/dreadnot/stacks/"]
