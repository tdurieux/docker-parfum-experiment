FROM alpine:latest
RUN apk add --no-cache bash openssl
COPY ssl/ /ssl
COPY docker/provision/ace/install_ssl_certs.sh .
RUN ./install_ssl_certs.sh \
    && tr -cd '[:alnum:]' < /dev/urandom | fold -w14 | head -n1 > mysql.ace-superuser.password \
    && tr -cd '[:alnum:]' < /dev/urandom | fold -w14 | head -n1 > mysql.ace-user.password