# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   "Aditya Patawari" <adimania@fedoraproject.org>

FROM centos:centos6
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; rm -rf /var/cache/yum yum clean all
RUN yum -y install python-pip; rm -rf /var/cache/yum yum clean all

ADD . /src

RUN cd /src; pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python", "/src/index.py"]
