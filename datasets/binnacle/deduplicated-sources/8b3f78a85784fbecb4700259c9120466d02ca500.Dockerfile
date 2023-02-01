FROM centos:7

MAINTAINER crunchy

RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y procps-ng postgresql94 hostname bind-utils unzip openssh-clients && yum clean all -y

RUN mkdir -p /var/cpm/bin

# open up the monitor server port
EXPOSE 8080

USER root

ADD bin /var/cpm/bin
ADD sbin /var/cpm/bin

CMD ["/var/cpm/bin/start-collect.sh"]
