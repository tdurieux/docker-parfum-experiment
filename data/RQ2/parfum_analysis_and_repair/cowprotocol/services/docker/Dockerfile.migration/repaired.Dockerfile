FROM docker.io/flyway/flyway:7.5.3

COPY database/sql sql/
COPY database/flyway.conf conf/