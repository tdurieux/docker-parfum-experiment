FROM osixia/openldap:latest

ENV LDAP_DOMAIN="planetexpress.com"
ENV LDAP_BASE_DN="dc=planetexpress,dc=com"

COPY ./configs/ldap /container/service/slapd/assets/config/bootstrap/ldif/custom