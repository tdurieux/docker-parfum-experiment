ARG MYSQL_VERSION=latest

FROM mysql:${MYSQL_VERSION}

CMD ["mysqld"]

EXPOSE 3306