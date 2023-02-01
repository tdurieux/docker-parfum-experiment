FROM dinkel/openldap

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y procps && rm -rf /var/lib/apt/lists/*;

# slapd get's updated by ldap-utils install, and this avoids its configuration
RUN echo slapd slapd/no_configuration boolean true | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ldap-utils && rm -rf /var/lib/apt/lists/*;

COPY schemas/ /etc/ldap.dist/schema/

ENV SLAPD_ADDITIONAL_SCHEMAS=eduperson

RUN sed -i '1i#!/bin/bash -x' /entrypoint.sh
