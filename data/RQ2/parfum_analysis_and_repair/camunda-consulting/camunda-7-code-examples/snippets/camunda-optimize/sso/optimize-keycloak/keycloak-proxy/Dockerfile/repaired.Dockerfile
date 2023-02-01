FROM jboss/keycloak-proxy:latest

USER root

RUN yum -y install xinetd && yum clean all && rm -rf /var/cache/yum
ADD xinetd.conf /etc/xinetd.conf

COPY ./conf/proxy.json /opt/jboss/conf/proxy.json

ENTRYPOINT /usr/sbin/xinetd && /opt/jboss/docker-entrypoint.sh "/opt/jboss/conf/proxy.json"
