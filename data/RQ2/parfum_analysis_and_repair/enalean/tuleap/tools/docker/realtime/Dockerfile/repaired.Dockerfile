FROM centos:7

COPY Tuleap.repo /etc/yum.repos.d/

RUN yum install -y tuleap-realtime openssl && \
    yum clean all && rm -rf /var/cache/yum

VOLUME ["/etc/tuleap-realtime", "/published-certificate"]
EXPOSE 443
