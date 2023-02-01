#
# Base Docker4Data image
#
# https://github.com/talos/docker4data
#

FROM debian:wheezy
MAINTAINER John Krauss <irving.krauss@gmail.com>

ENV LANG en_US.UTF8
ENV LC_ALL en_US.UTF8
ENV LANGUAGE en_US.UTF8
ENV PATH /usr/lib/postgresql/9.4/bin:$PATH
ENV PASSWORD docker4data

COPY scripts /scripts
COPY conf /conf
COPY site /site
COPY cli /cli

RUN apt-get update --fix-missing
RUN apt-get install -y freetds-dev wget openssl ca-certificates \
  apt-transport-https git-core time pv

RUN echo "===> add user and group to make sure their IDs get assigned consistently" && \
  groupadd -r postgres && useradd -r -g postgres postgres && \
  \
  \
  echo "===> grab gosu for easy step-down from root" && \
  wget -O /usr/local/bin/gosu \
      https://github.com/tianon/gosu/releases/download/1.1/gosu  && \
  chmod +x /usr/local/bin/gosu && \
  \
  \
  echo "make en_US.UTF-8 locale so postgres will be utf-8 enabled by default" && \
  apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN echo "===> install postgres" && \
  echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" | tee \
    /etc/apt/sources.list.d/wheezy-pgdg.list  && \
  wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-common && \
  sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && \
  apt-get install -y postgresql-9.4-postgis-2.1 postgresql-contrib pgtune && \
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
RUN mkdir -p /data && chown -R postgres /data

RUN /scripts/createdb.sh

RUN echo "===> install postgis" && \
    gosu postgres pg_ctl -D /var/lib/postgresql/data -w start && \
    gosu postgres psql < /usr/share/postgresql/9.4/contrib/postgis-2.1/postgis.sql && \
    gosu postgres psql < /usr/share/postgresql/9.4/contrib/postgis-2.1/spatial_ref_sys.sql && \
    gosu postgres pg_ctl -D /var/lib/postgresql/data stop

#apt-get remove -y freetds-dev openssl ca-certificates \
#  apt-transport-https

RUN git clone https://github.com/talos/docker4data.git
RUN mkdir /logs

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
EXPOSE 5432

ENTRYPOINT "/scripts/docker-entrypoint.sh"
