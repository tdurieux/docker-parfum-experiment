#
# For testing Sumatra's postgresql support
#
# based on example Dockerfile from http://docs.docker.io/en/latest/examples/postgresql_service/ by SvenDowideit@docker.com
#
# Usage:  docker build -t postgresql_test -f Dockerfile.postgres .

FROM debian:jessie
MAINTAINER andrew.davison@unic.cnrs-gif.fr

RUN apt-get update
RUN apt-get -y --no-install-recommends -q install python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends -q install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 && rm -rf /var/lib/apt/lists/*;

USER postgres
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker sumatra_test

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
