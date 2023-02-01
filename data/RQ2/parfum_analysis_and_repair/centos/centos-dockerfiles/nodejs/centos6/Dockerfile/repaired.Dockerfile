# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   "Jason Clark" <jclark@redhat.com>

FROM centos:centos6
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; rm -rf /var/cache/yum yum clean all
RUN yum -y install nodejs npm; rm -rf /var/cache/yum yum clean all

ADD . /src

RUN cd /src; npm install && npm cache clean --force;

EXPOSE 8080

CMD ["node", "/src/index.js"]
