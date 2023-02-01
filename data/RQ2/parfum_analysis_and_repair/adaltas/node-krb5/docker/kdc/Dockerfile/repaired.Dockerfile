FROM centos:7
MAINTAINER SequenceIQ

# EPEL
RUN yum install -y epel-release && rm -rf /var/cache/yum

# kerberos
RUN yum install -y krb5-server krb5-libs krb5-auth-dialog krb5-workstation && rm -rf /var/cache/yum

EXPOSE 88 749

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]