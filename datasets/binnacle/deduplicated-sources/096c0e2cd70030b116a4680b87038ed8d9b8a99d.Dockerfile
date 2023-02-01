FROM centos:7
MAINTAINER crunchy

RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y procps-ng postgresql94 postgresql94-server unzip openssh-clients hostname bind-utils && yum clean all -y

RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf
RUN chown -R postgres:postgres /var/cpm
ENV PGROOT /usr/pgsql-9.4
ENV PGDATA /pgdata
ADD conf/.bash_profile /var/lib/pgsql/

ADD sbin /var/cpm/bin
ADD bin /var/cpm/bin

VOLUME ["/cpmlogs"]
RUN chown -R postgres:postgres /cpmlogs

USER postgres

CMD ["/var/cpm/bin/start-backupjob.sh"]
