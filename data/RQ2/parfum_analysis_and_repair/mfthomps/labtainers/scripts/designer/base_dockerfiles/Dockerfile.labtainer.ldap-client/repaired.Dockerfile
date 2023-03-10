ARG registry
ARG apt_source
FROM $registry/labtainer.centos.xtra
LABEL description="This is base Docker image for Labtainer LDAP clients"
ENV APT_SOURCE $apt_source
RUN /usr/bin/yum-source.sh

#
# Labtainer base image for CENTOS builds
RUN yum -y install openldap-clients nss-pam-ldapd nscd openssl authconfig chkconfig && rm -rf /var/cache/yum
#RUN ln -s /usr/sbin/chkconfig /sbin/chkconfig
