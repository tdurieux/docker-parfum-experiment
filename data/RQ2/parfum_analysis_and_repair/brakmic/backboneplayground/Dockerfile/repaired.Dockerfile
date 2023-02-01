# DOCKER-VERSION 1.3.0

FROM    centos:centos6

# Enable EPEL for Node.js
RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN yum install -y npm && rm -rf /var/cache/yum

# Bundle app source
COPY . /src

# Install app dependencies
RUN cd /src; npm install && npm cache clean --force;

EXPOSE  3000

CMD ["node", "/src/server.js"]
