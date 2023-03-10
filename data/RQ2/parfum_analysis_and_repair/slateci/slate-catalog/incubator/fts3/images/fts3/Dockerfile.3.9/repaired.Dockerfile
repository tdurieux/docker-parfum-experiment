FROM opensciencegrid/software-base:fresh
LABEL description="File Transfer Service from CERN"
LABEL maintainer=lincolnb@uchicago.edu

ADD "http://fts-repo.web.cern.ch/fts-repo/fts3-prod-el7.repo" "/etc/yum.repos.d/"
#ADD "https://fts-repo.web.cern.ch/fts-repo/fts3-rc-el7.repo" "/etc/yum.repos.d/"
#ADD "https://dmc-repo.web.cern.ch/dmc-repo/dmc-rc-el7.repo" "/etc/yum.repos.d/"
#RUN /bin/sed -i '/^enabled=1/a priority=97' /etc/yum.repos.d/dmc-rc-el7.repo
# Install OSG certificates
RUN yum install -y osg-ca-certs && rm -rf /var/cache/yum
# Install FTS + GFAL
RUN yum install -y gfal2-all gfal2-util fts-server-3.9.5 fts-client-3.9.5 fts-rest-3.9.4 fts-monitoring-3.9.1 fts-mysql-3.9.5 fts-server-selinux-3.9.5 fts-rest-selinux-3.9.4 fts-monitoring-selinux-3.9.1 fts-msg-3.9.5 fts-infosys-3.9.5 && rm -rf /var/cache/yum

# Install the VO Client
RUN yum install -y vo-client && rm -rf /var/cache/yum

ADD fetch-crl /etc/cron.d/fetch-crl
RUN chmod 644 /etc/cron.d/fetch-crl

# remove me when we can remove the old way how this chart works
#COPY /fts3config etc/fts3/fts3config
#COPY fts-msg-monitoring.conf /etc/fts3/fts-msg-monitoring.conf
#COPY fts-schema-6.0.0.sql /etc/fts3/fts-schema-6.0.0.sql

COPY 10-fts.conf /etc/supervisord.d/
COPY 20-fts-config.sh /etc/osg/image-config.d/

ENTRYPOINT ["/usr/local/sbin/supervisord_startup.sh"]
