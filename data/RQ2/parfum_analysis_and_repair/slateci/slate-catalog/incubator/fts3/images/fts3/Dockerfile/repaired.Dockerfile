FROM opensciencegrid/software-base:el7-fresh
LABEL description="File Transfer Service from CERN"
LABEL maintainer=lincolnb@uchicago.edu

ADD "http://fts-repo.web.cern.ch/fts-repo/fts3-prod-el7.repo" "/etc/yum.repos.d/"
#ADD "https://fts-repo.web.cern.ch/fts-repo/fts3-rc-el7.repo" "/etc/yum.repos.d/"
ADD "https://dmc-repo.web.cern.ch/dmc-repo/dmc-rc-el7.repo" "/etc/yum.repos.d/"
#RUN /bin/sed -i '/^enabled=1/a priority=97' /etc/yum.repos.d/dmc-rc-el7.repo
# Install OSG certificates
RUN yum install -y osg-ca-certs && rm -rf /var/cache/yum
# Install FTS + GFAL
RUN yum install --disablerepo=osg --disablerepo=osg-testing -y gfal2-all gfal2-util fts-server fts-client fts-rest fts-monitoring fts-mysql fts-server-selinux fts-rest-selinux fts-monitoring-selinux fts-msg fts-infosys && rm -rf /var/cache/yum

ADD fetch-crl /etc/cron.d/fetch-crl
RUN chmod 644 /etc/cron.d/fetch-crl

# remove me when we can remove the old way how this chart works
#COPY /fts3config etc/fts3/fts3config
#COPY fts-msg-monitoring.conf /etc/fts3/fts-msg-monitoring.conf
#COPY fts-schema-6.0.0.sql /etc/fts3/fts-schema-6.0.0.sql

COPY 10-fts.conf /etc/supervisord.d/
COPY 20-fts-config.sh /etc/osg/image-config.d/

ENTRYPOINT ["/usr/local/sbin/supervisord_startup.sh"]
