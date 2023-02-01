FROM fedora:20
MAINTAINER mgoldboi <mgoldboi@redhat.com>
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#RUN yum -y update && yum clean all
RUN yum -y install postgresql postgresql-server postgresql-contrib supervisor && yum clean all

ADD ./supervisord.conf /etc/supervisord.conf

RUN sed -i -e '2,2ialias system=echo' -e '2,2ifunction systemctl() { echo "Environment=PGPORT=5432 PGDATA=/var/lib/pgsql/data"; }' /usr/bin/postgresql-setup && \
( tail -F /var/lib/pgsql/initdb.log & tailpid=$!; \
export $(locale 2>>/dev/null|tr -d '\\"') ; \
/usr/bin/postgresql-setup initdb && \
kill $tailpid )

RUN echo "host all all 0.0.0.0/0 trust" >> /var/lib/pgsql/data/pg_hba.conf
RUN echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf

USER postgres
RUN /usr/bin/supervisord && sleep 5 && \
psql -d template1 -c "create user engine password 'engine';" && \
psql -d template1 -c "create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';"

WORKDIR /var/lib/pgsql

EXPOSE 5432

USER root
CMD ["/usr/bin/supervisord", "-n"]
