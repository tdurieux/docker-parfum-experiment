#ARGS
ARG MYSQL_TAG=${MYSQL_TAG}

FROM mysql:${MYSQL_TAG}

ARG MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
# MySql database parameters