FROM    centos:6.4

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN yum install -y npm && rm -rf /var/cache/yum
RUN yum install git -y && rm -rf /var/cache/yum

# Bundle app source
ADD . /src
# Install app dependencies
RUN cd /src; npm install && npm cache clean --force;
EXPOSE 8080

CMD ["/bin/bash", "/src/start.sh"]
