FROM rhel7
MAINTAINER crunchy

# Install postgresql deps
# set up cpm directory
#
RUN mkdir -p /var/cpm/bin
RUN mkdir -p /var/cpm/conf
RUN chown -R daemon:daemon /var/cpm/bin
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
RUN yum install -y rsyslog procps-ng postgresql94 postgresql94-contrib pgpool-II-94 libxslt which unzip openssh-clients hostname && yum clean all -y


VOLUME ["/syslogconfig"]

# set environment vars

# open up the pgpool port
EXPOSE 5432

ADD bin /var/cpm/bin
ADD sbin /var/cpm/bin
ADD conf/pgpool /var/cpm/conf/pgpool
ADD conf/pgpool/pool_hba.conf  /etc/pgpool-II-94/pool_hba.conf
ADD conf/pgpool/pool_passwd /etc/pgpool-II-94/pool_passwd

USER daemon

CMD ["/var/cpm/bin/start-cpmcontainerapi.sh"]
