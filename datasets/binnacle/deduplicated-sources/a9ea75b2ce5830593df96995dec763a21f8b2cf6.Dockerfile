ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache mariadb mariadb-client

# Copy data
COPY run.sh /
COPY mariadb-server.cnf /etc/my.cnf.d/

CMD [ "/run.sh" ]
