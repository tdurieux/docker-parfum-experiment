FROM debian:buster
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update && apt-get -y --no-install-recommends install vim git pgbouncer telnet postgresql-client && rm -rf /var/lib/apt/lists/*;

# Expose standard for PostGreSQL and pgboucer
EXPOSE 6432

# Share volumes
VOLUME  ["/etc/pgbouncer"]

ADD conf/pgbouncer/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
ADD conf/pgbouncer/userlist.txt /etc/pgbouncer/userlist.txt

RUN mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
	chown -R postgres /var/run/pgbouncer /etc/pgbouncer

USER postgres

CMD ["/bin/bash", "-c", "pgbouncer -R /etc/pgbouncer/pgbouncer.ini"]
