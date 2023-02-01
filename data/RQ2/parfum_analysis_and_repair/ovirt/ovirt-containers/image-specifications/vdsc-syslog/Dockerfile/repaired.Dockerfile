FROM {{ tag "base" }}

MAINTAINER "Yaniv Bronhaim" <ybronhei@redhat.com>

RUN yum -y install rsyslog && yum -y clean all && rm -rf /var/cache/yum

EXPOSE 514 514/tcp

COPY root /

ENTRYPOINT /entrypoint.sh
