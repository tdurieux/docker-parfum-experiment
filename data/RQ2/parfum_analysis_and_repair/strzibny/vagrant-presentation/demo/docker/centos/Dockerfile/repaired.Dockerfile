FROM tutum/centos
MAINTAINER "Jason Clark" <jclark@redhat.com>

RUN yum -y update; yum clean all
RUN yum -y install npm; rm -rf /var/cache/yum yum clean all

ADD . /src

RUN cd /src; npm install && npm cache clean --force;

EXPOSE 8080

CMD ["node", "/src/index.js"]
