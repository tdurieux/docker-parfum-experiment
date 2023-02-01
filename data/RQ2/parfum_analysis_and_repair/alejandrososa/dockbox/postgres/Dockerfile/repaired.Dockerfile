FROM postgres:latest

MAINTAINER Alejandro Sosa <alesjohnson@hotmail.com>

ENV TERM xterm

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes nano vim && rm -rf /var/lib/apt/lists/*;

ADD ./sql/*.sh /docker-entrypoint-initdb.d/
COPY ./pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
COPY ./postgresql.conf /var/lib/postgresql/data/postgresql.conf

USER root
RUN mkdir -p /var/lib/postgresql/backup
RUN chmod 777 /var/lib/postgresql/backup
RUN chmod 777 /var/lib/postgresql/data

VOLUME ["/var/log/postgresql/", "var/lib/postgresql/data", "var/lib/postgresql/backup"]
CMD ["postgres"]
EXPOSE 5432