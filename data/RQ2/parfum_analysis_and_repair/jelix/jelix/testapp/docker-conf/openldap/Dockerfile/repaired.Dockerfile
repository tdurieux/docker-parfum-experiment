# -----------------
# Openldap service
#
# from https://github.com/dinkel/docker-openldap
# -----------------
FROM debian:stretch
MAINTAINER Jelix

# properly setup debian sources
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get install -y --no-install-recommends \
      slapd \
      ldap-utils \
      openssl ssl-cert \
    && apt-get clean \
    && adduser openldap ssl-cert \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mv /etc/ldap /etc/ldap.dist

COPY entrypoint.sh /entrypoint.sh
COPY ctl.sh /bin/ctl.sh

# Expose default ldap and ldaps ports