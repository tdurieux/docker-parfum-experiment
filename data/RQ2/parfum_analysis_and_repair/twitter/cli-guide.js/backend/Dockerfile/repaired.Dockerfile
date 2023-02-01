FROM    centos:centos6

# Enable Extra Packages for Enterprise Linux (EPEL) for CentOS
RUN yum install -y epel-release && rm -rf /var/cache/yum
# Install Node.js and npm
RUN yum install -y nodejs npm && rm -rf /var/cache/yum

# Install app dependencies
COPY package.json /src/package.json
RUN cd /src; npm install && npm cache clean --force;

# Bundle app source
COPY . /src

EXPOSE  8080
CMD ["node", "/src/index.js"]
