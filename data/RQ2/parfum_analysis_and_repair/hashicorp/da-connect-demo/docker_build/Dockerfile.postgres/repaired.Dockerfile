FROM postgres:10.4-alpine

RUN apk update; apk add --no-cache curl jq ngrep
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY ./consul /usr/local/bin/consul
COPY ./consul_agent.hcl /etc/consul.d/consul.hcl
COPY ./startup_postgres.sh /docker-entrypoint-initdb.d/startup_postgres.sh

EXPOSE 5432
