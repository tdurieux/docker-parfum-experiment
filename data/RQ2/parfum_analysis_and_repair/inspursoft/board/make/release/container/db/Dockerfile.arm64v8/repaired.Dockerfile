FROM arm64v8/mariadb:10

WORKDIR /tmp

ADD make/release/container/db/board.sql r.sql

ADD make/release/container/db/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

CMD ["mysqld_safe"]