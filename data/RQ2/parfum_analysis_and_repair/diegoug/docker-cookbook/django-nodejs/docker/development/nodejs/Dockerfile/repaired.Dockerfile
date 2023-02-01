FROM centos:centos7
MAINTAINER diego.uribe.gamez@gmail.com

RUN yum -y update
RUN yum -y install wget && rm -rf /var/cache/yum
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install gcc gcc-c++ && rm -rf /var/cache/yum
RUN yum -y install make && rm -rf /var/cache/yum
RUN yum clean all

RUN mkdir node-latest
RUN cd node-latest && wget https://nodejs.org/dist/v6.9.2/node-v6.9.2.tar.gz
RUN cd node-latest && tar xvf node-v6.9.2.tar.gz && rm node-v6.9.2.tar.gz
RUN cd node-latest && cd * && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd node-latest && cd * && make
RUN cd node-latest && cd * && make install
RUN ln -s /usr/local/bin/node /usr/bin/node
RUN ln -s /usr/local/bin/npm /usr/bin/npm
RUN cd ../../ && rm node-latest/ -r -f

RUN npm install -g node-inspector supervisor forever && npm cache clean --force;

COPY package.json /opt/package.json
RUN cd /opt/ && npm install && npm cache clean --force;
RUN rm -f /opt/package.json
