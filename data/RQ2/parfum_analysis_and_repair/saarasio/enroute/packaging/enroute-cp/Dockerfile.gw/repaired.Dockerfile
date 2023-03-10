#FROM golang:1.12.7 AS build
#FROM envoyproxy/envoy:latest

# (1) Copy/Install Artifacts
	# (1.1) Install postgresql on container
	# (1.2) Install supervisord on container
	# (1.3) Copy migrations to container
	# (1.4) Copy hasura binaries to container
   # (1.4.1) Make hasura binaries executable
   # (1.4.2) Copy hasura migrations script
	# (1.5) Copy supervisord config file
	# (1.6) Copy script that waits for hasura
	# (1.7) Copy enroute-cp

# (2) Setup environment variables
	# (2.1) Setup environment variables to run migrations script

# (2) Run supervisord
	# (3.1) Start postgresql
	# (3.2) Run migrations with autorestart to false - only runs it once
    # (3.2.1) Migration script runs hasura temporarily and then kills it.
	# (3.3) Start hasura

FROM ubuntu:jammy

WORKDIR /bin

# 1.1
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu jammy-security main"
RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 libicu-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-key adv --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
COPY ACCC4CF8.asc .
RUN cat ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common postgresql-11 postgresql-client-11 postgresql-contrib-11 && rm -rf /var/lib/apt/lists/*;

#1.2
RUN apt-get update && apt-get install --no-install-recommends -y supervisor vim netcat net-tools sed curl jq && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisord

# 1.3
RUN ["mkdir", "-p", "/migrations"]
COPY migrations/* /migrations/

# 1.4
COPY hasura/* /bin/

# 1.4.1
RUN chmod +x /bin/hasura-cli

# 1.4.2
COPY run_migrations.sh /bin/
RUN chmod +x /bin/run_migrations.sh

# 1.4.3
COPY run_pg_prep.sh /bin/
RUN chmod +x /bin/run_pg_prep.sh

COPY run_enroute_envoy.sh /bin/
RUN chmod +x /bin/run_enroute_envoy.sh

# 1.4.5
COPY redis-server /bin/

# 1.4.6
#RUN ["mkdir", "-p", "/prom"]
#COPY prom/* /prom/
#
#RUN ["mkdir", "-p", "/graf"]
#COPY graf/* /graf/

RUN ["mkdir", "-p", "/examples"]
COPY petstore.json /examples/

#WORKDIR /prom
#RUN ["tar", "-xzf", "/prom/prometheus-2.19.0.linux-amd64.tar.gz"]
#RUN ["chown", "-R", "postgres:postgres", "/prom"]
#RUN ["chmod", "-R", "+x", "/prom/prometheus-2.19.0.linux-amd64/data"]
#WORKDIR /graf
#RUN ["tar", "-xzf", "grafana-7.0.3.linux-amd64.tar.gz"]
#RUN ["chown", "-R", "postgres:postgres", "/graf"]
#RUN ["chmod", "-R", "+x", "/graf/grafana-7.0.3/data"]
#WORKDIR /examples
#RUN ["chown", "-R", "postgres:postgres", "/examples"]

WORKDIR /bin

# 1.5
COPY supervisord.conf.gw /etc/supervisor/conf.d/supervisord.conf

# 1.7 copy enroute-cp, envoy
COPY enroute-cp /bin/
COPY envoy /bin/
COPY enroute /bin/
COPY enroutectl /bin/

ENV HASURA_GRAPHQL_CLI_ENVIRONMENT=server-on-docker
ENV HASURA_GRAPHQL_DATABASE_URL=postgres://postgres:@localhost:5432/postgres
ENV HASURA_GRAPHQL_ENABLE_CONSOLE="true"
ENV HASURA_GRAPHQL_MIGRATIONS_DIR=/migrations
ENV HASURA_GRAPHQL_SERVER_PORT=8888

# Only allow connections from localhost
RUN echo "host all  all    127.0.0.1/32  trust" >> /etc/postgresql/11/main/pg_hba.conf
# Only listen on localhost
# RUN echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf

# Allow other processes to reach posgresql on port 5432
EXPOSE 5432

# Allow other processes to reach hasura on port 8888
EXPOSE 8888

# Setup volume for postgresql
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/lib/postgresql/11/main"]

ENV DB_PORT=8888
ENV DB_HOST=127.0.0.1
ENV WEBAPP_SECRET=""
ENV SEND_ANON_STAT="1"

RUN mkdir -p /supervisord
RUN chown -R postgres:postgres /supervisord

# Hasura creates a /root/.config for global config, since we run as postgres, provide access to /root directory to postgres
# /root is empty and this only reduces permissions on /root, so should be OK
RUN chown -R postgres:postgres /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
