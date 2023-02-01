FROM centos:7

MAINTAINER crunchy

# Install postgresql deps
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y epel-release rsyslog expect perl perl-IO-String perl-Thread-Queue perl-JSON-PP perl-Digest-SHA perl-DBD-Pg procps-ng postgresql94 postgresql94-contrib postgresql94-server libxslt unzip openssh-clients hostname bind-utils pgbadger && yum clean all -y

RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf

ENV PGROOT /usr/pgsql-9.4
ENV PGDATA /pgdata
ADD bin/.bash_profile /var/lib/pgsql/
VOLUME ["/pgdata"]
RUN chown -R postgres:postgres /pgdata

VOLUME ["/syslogconfig"]

# add volumes to allow restore
VOLUME ["/keys"]
RUN chown -R root:root /keys

ADD backrest/bin  /usr/local/bin
ADD backrest/lib  /usr/local/lib

ADD sql /var/cpm/bin
ADD bin /var/cpm/bin
ADD sbin /var/cpm/bin
ADD conf /var/cpm/conf

EXPOSE 5432
EXPOSE 13000

USER root

CMD ["/var/cpm/bin/start-cpmcontainerserver.sh"]
