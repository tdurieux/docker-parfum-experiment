FROM inspursoft/mysql-mips:5.6.45

WORKDIR /tmp

ADD make/dev/container/db/board.sql r.sql

ADD make/dev/container/db/docker-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh