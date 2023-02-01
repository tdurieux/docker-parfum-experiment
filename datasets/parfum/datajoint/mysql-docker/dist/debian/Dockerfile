ARG  MYSQL_VER=5.7
FROM mysql:${MYSQL_VER}

LABEL maintainerName="Raphael Guzman" \
      maintainerEmail="raphael@vathes.com" \
      maintainerCompany="DataJoint"

RUN \
    apt-get update && \
    apt-get install openssl -y && \
    mkdir /mysql_keys && \
    chown mysql:mysql /mysql_keys

USER mysql
RUN \
    cd /mysql_keys;\
    # Create CA certificate
    openssl genrsa 2048 > ca-key.pem;\
    openssl req -subj '/CN=CA/O=MySQL/C=US' -new -x509 -nodes -days 3600 \
            -key ca-key.pem -out ca.pem;\
    # Create server certificate, remove passphrase, and sign it
    # server-cert.pem = public key, server-key.pem = private key
    openssl req -subj '/CN=SV/O=MySQL/C=US' -newkey rsa:2048 -days 3600 \
            -nodes -keyout server-key.pem -out server-req.pem;\
    openssl rsa -in server-key.pem -out server-key.pem;\
    openssl x509 -req -in server-req.pem -days 3600 \
            -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem;\
    # Create client certificate, remove passphrase, and sign it
    # client-cert.pem = public key, client-key.pem = private key
    openssl req -subj '/CN=CL/O=MySQL/C=US' -newkey rsa:2048 -days 3600 \
            -nodes -keyout client-key.pem -out client-req.pem;\
    openssl rsa -in client-key.pem -out client-key.pem;\
    openssl x509 -req -in client-req.pem -days 3600 \
            -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
USER root   

ADD ./utilities/datajoint-entrypoint.sh /datajoint-entrypoint.sh
COPY --chown=mysql:mysql ./config/my.cnf /etc/mysql/my.cnf
RUN chmod g+w /etc/mysql/my.cnf
ENTRYPOINT ["/datajoint-entrypoint.sh"]
CMD ["mysqld"]
HEALTHCHECK       \
    --timeout=30s \
    --retries=5  \
    --interval=15s \
    CMD           \
        mysql --protocol TCP -u"root" -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;"

ENV DATAJOINT_DATABASE_CONFIG_MONITOR FALSE
