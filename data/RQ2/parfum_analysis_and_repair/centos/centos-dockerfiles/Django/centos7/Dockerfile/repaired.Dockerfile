# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   Aditya Patawari <adimania@fedoraproject.org>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install python-pip python-django git sqlite; rm -rf /var/cache/yum yum clean all

EXPOSE 8000

CMD [ "/bin/bash" ]

