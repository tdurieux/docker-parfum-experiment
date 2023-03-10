ARG registry
ARG apt_source
FROM $registry/labtainer.centos.xtra
LABEL description="This is base Docker image for Labtainer LDAP servers"
ENV APT_SOURCE $apt_source
RUN /usr/bin/yum-source.sh

#
# Labtainer base image for CENTOS builds
RUN yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel openssl && rm -rf /var/cache/yum
RUN systemctl enable slapd
