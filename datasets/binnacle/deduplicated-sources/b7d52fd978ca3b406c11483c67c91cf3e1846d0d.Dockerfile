FROM rhel7
MAINTAINER crunchy

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
RUN yum install -y docker procps-ng postgresql94 postgresql94-server sysstat procps-ng unzip openssh-clients hostname bind-utils && yum clean all -y

RUN mkdir -p /var/cpm/bin

ADD sbin /var/cpm/bin
ADD bin /var/cpm/bin

EXPOSE 10001

USER root

CMD ["/var/cpm/bin/start.sh"]
