FROM centos:7
MAINTAINER crunchy

RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y procps-ng postgresql94 postgresql94-server libxslt unzip openssh-clients hostname bind-utils  && yum clean all -y

RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf

ENV PGROOT /usr/pgsql-9.4

# add path settings for postgres user
ADD conf/.bash_profile /var/lib/pgsql/

ADD sbin /var/cpm/bin
ADD bin /var/cpm/bin
ADD conf /var/cpm/conf

USER postgres

VOLUME ["/pgdata"]

CMD ["/var/cpm/bin/start-restore-job.sh"]
