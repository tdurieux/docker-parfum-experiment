FROM rhel7
MAINTAINER crunchy

# Install postgresql deps
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-rhel7-9.4-1.noarch.rpm
RUN yum install -y procps-ng postgresql94 postgresql94-contrib postgresql94-server libxslt unzip openssh-clients hostname bind-utils pgbadger

RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf

ENV PGROOT /usr/pgsql-9.4
ENV PGDATA /pgdata

ADD bin/.bash_profile /var/lib/pgsql/

VOLUME ["/pgdata"]
RUN chown -R postgres:postgres /pgdata

ADD sql /var/cpm/bin/
ADD bin /var/cpm/bin/
ADD sbin /var/cpm/bin/
ADD conf /var/cpm/conf/

EXPOSE 5432
EXPOSE 13000

USER postgres

CMD ["/var/cpm/bin/startadmin.sh"]
