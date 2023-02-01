FROM alpine:3.9

ARG VERSION

LABEL maintainer="zgist" \
        org.label-schema.name="MariaDB" \
        org.label-schema.version=$VERSION

RUN set -ex && \
    apk add --no-cache bash mariadb mariadb-client mariadb-server-utils && \
    mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld

COPY docker-entrypoint.sh /

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD /usr/bin/mysqld \
    --user=mysql \
    --console \
    --skip-name-resolve \
    --skip-networking=0
