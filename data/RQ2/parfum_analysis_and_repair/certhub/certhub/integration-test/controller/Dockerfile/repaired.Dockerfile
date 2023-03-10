FROM certhub-integration-base

RUN yum install -y epel-release && rm -rf /var/cache/yum

RUN yum install -y \
    certbot \
    libfaketime \
    python-dns-lexicon && rm -rf /var/cache/yum

RUN yum install -y --enablerepo=epel-testing dehydrated && rm -rf /var/cache/yum

ARG WITH_TOR=0
RUN [ $WITH_TOR -eq 0 ] || yum -y install tor && rm -rf /var/cache/yum
RUN [ $WITH_TOR -eq 0 ] || systemctl enable tor

# Note: tor fails to start up if any of the directories specified in its
# services file is missing.
RUN [ $WITH_TOR -eq 0 ] || mkdir /boot

# Add home directory structure
COPY --chown=certhub:certhub context/home /var/lib/certhub/

# Add config directory
COPY context/etc /etc/certhub
