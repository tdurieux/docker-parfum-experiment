FROM centos:6.6

ARG COMMIT_ID=unknown
LABEL io.confluent.docker.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL io.confluent.docker.build.number=$BUILD_NUMBER
LABEL io.confluent.docker=true

# EPEL
#RUN yum install -y epel-release

# kerberos
RUN yum install -y krb5-server krb5-libs krb5-auth-dialog krb5-workstation && rm -rf /var/cache/yum

EXPOSE 88 749

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]
