FROM centos:7

RUN \
  yum update -y && \
  yum install -y epel-release && rm -rf /var/cache/yum

RUN \
  yum install -y openssh-server pwgen supervisor authconfig && rm -rf /var/cache/yum

RUN yum install openssl -y \
    yum install -y openldap-clients pam_ldap nss-pam-ldap authconfig && rm -rf /var/cache/yum

RUN \
  echo > /etc/sysconfig/i18n

RUN \
  yum clean all && rm -rf /tmp/yum*

ADD container-files /

ENTRYPOINT ["/config/bootstrap.sh"]
