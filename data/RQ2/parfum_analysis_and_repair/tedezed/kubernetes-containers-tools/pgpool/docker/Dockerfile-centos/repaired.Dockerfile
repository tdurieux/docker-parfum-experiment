FROM centos:7
MAINTAINER Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>

LABEL name="crunchydata/pgpool" \
        vendor="crunchy data" \
        version="7.3" \
      	PostgresVersion="9.6" \
      	PostgresFullVersion="9.6.5" \
        release="1.6.0" \
        build-date="2017-10-13" \
        url="https://crunchydata.com" \
        summary="Contains the pgpool utility as a PostgreSQL-aware load balancer" \
        description="Offers a smart load balancer in front of a Postgres cluster, sending writes only to the primary and reads to the replica(s). This allows an application to only have a single connection point when interacting with a Postgres cluster." \
        io.k8s.description="pgpool container" \
        io.k8s.display-name="Crunchy pgpool container" \
        io.openshift.expose-services="" \
        io.openshift.tags="crunchy,database"

ENV PGVERSION="9.6" PGDG_REPO="pgdg-centos96-9.6-3.noarch.rpm"

RUN rpm -Uvh https://download.postgresql.org/pub/repos/yum/${PGVERSION}/redhat/rhel-7-x86_64/${PGDG_REPO}

RUN yum -y update && yum -y install hostname \
	gettext \
	openssh-clients \
	procps-ng \
	&& yum -y install postgresql96 pgpool-II-96 pgpool-II-96-extensions && rm -rf /var/cache/yum
RUN yum -y install nano nmap sudo \
RUN yum -y clean all && rm -rf /var/cache/yum

RUN mkdir -p /opt/cpm/bin /opt/cpm/conf

# add volumes to allow override of pgpool config files
VOLUME ["/pgconf"]

# open up the postgres port
EXPOSE 5432 9898

ADD bin/pgpool /opt/cpm/bin
ADD conf/pgpool /opt/cpm/conf/pgpool
ADD conf/pgpool/pool_hba.conf  /etc/pgpool-II-96/pool_hba.conf
ADD conf/pgpool/pool_passwd /etc/pgpool-II-96/pool_passwd

RUN chown -R daemon:daemon /opt/cpm/bin /pgconf \
    && chmod +x /opt/cpm/bin/*

RUN touch /etc/pgpool-II-96/pcp.conf \
    && chown daemon:daemon /etc/pgpool-II-96/pcp.conf

#RUN echo "daemon   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV PGHOST="/tmp/" \
    PCP_HOST="/tmp" \
    PCP_PORT="9898" \
    PCPPASSFILE="/tmp/.pcppass" \
    PCPUSER="admin" \
    PCPPASS="admin" \
    PG_NUM_INIT_CHILDREN="400" \
    PG_MULTIPLER_BACK="8" \
    PG_MAX_POOL="4" \
    PG_CHILD_LIFE_TIME="3600" \
    PG_CLIENT_IDLE_LIMIT="3600" \
    PG_MAX_CONNECTIONS="1642" \
    PG_SUPERUSER_RESERVED_CONNECTIONS="20" \
    PG_DEBUG="1" \
    PG_LOG="on" \
    TIME_FAILOVER="600" \
    DOCKER_DEBUG="off"

USER daemon

CMD ["/opt/cpm/bin/startpgpool.sh"]