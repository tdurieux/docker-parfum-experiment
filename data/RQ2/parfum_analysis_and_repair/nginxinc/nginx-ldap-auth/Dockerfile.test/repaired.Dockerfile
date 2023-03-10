ARG PYTHON_VERSION=2
FROM python:${PYTHON_VERSION}-alpine

WORKDIR /usr/src/app/
COPY nginx-ldap-auth-daemon.py /usr/src/app/

WORKDIR /tests
COPY t/ldap-auth.t /tests
COPY t/runtests.sh /tests

# Install required software
RUN \
    apk --no-cache add openldap-dev && \
    apk --no-cache add openldap && \
    apk --no-cache add openldap-back-hdb && \
    apk --no-cache add openldap-clients && \
    apk --no-cache add openssl && \
    apk --no-cache add nginx && \
    apk --no-cache add nginx-mod-http-geoip && \
    apk --no-cache add nginx-mod-stream-geoip && \
    apk --no-cache add nginx-mod-http-image-filter && \
    apk --no-cache add nginx-mod-stream && \
    apk --no-cache add nginx-mod-mail && \
    apk --no-cache add nginx-mod-http-perl && \
    apk --no-cache add nginx-mod-http-xslt-filter && \
    apk --no-cache add mercurial && \
    apk --no-cache add perl && \
    apk --no-cache add --virtual build-dependencies build-base && \
    pip install --no-cache-dir python-ldap && \
    pip install --no-cache-dir coverage && \
    apk del build-dependencies


# Install tests
RUN \
    cd /tests && \
    hg clone https://hg.nginx.org/nginx-tests && \
    mv ldap-auth.t nginx-tests

WORKDIR /usr/src/app/

ENV TEST_LDAP_DAEMON=/usr/sbin/slapd
ENV TEST_LDAP_AUTH_DAEMON=/usr/src/app/nginx-ldap-auth-daemon.py
ENV TEST_NGINX_BINARY=/usr/sbin/nginx
ENV TEST_NGINX_MODULES=/usr/lib/nginx/modules
ENV LDAPTLS_REQCERT=never

WORKDIR /tests/nginx-tests

CMD ["/tests/runtests.sh"]
