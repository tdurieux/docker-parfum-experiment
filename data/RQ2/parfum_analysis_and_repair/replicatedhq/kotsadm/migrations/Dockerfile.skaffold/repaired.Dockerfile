FROM node:10
ADD . /src
WORKDIR /src/fixtures
RUN rm -rf node_modules
RUN make deps build run

FROM postgres:10.7

COPY --from=0 /src/fixtures/fixtures.sql /docker-entrypoint-initdb.d/fixtures.sql

RUN useradd -c 'kotsadm-migrations user' -m -d /home/kotsadm-migrations -s /bin/bash -u 1001 kotsadm-migrations
RUN chown -R kotsadm-migrations.kotsadm-migrations /src/fixtures/fixtures.sql
RUN chown -R kotsadm-migrations.kotsadm-migrations /docker-entrypoint-initdb.d/fixtures.sql
USER kotsadm-migrations
ENV HOME /home/kotsadm-migrations