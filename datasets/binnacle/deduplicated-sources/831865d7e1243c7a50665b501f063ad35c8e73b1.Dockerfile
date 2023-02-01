FROM arm64v8/alpine:edge
MAINTAINER Julian Xhokaxhiu <info at julianxhokaxhiu dot com>

# Environment variables
#######################

ENV DATA_DIR /srv/data
ENV QEMU_EXECVE 1

# Configurable environment variables
####################################

# Custom DNS where to forward your request, if not found inside the DNS Server.
# By default this will be forwarded to Google DNS for IPv4 and IPv6 requests.
# See https://doc.powerdns.com/md/recursor/settings/#forward-zones
ENV CUSTOM_DNS "8.8.8.8;8.8.4.4;[2001:4860:4860::8888];[2001:4860:4860::8844]"

# Custom API Key for PowerDNS.
# Leave empty to autogenerate one ( HIGHLY SUGGESTED! )
# See https://doc.powerdns.com/md/authoritative/settings/#api-key
ENV API_KEY ""

# Change this cron rule to what fits best for you.
# Used only if ENABLE_ADBLOCK=true
# By Default = At 10:00 UTC ~ 2am PST/PDT
ENV CRONTAB_TIME '0 10 * * *'

# Enable the AdBlock feature
ENV ENABLE_ADBLOCK false

# Create Volume entry points
############################

VOLUME $DATA_DIR

# Copy required files and fix permissions
#########################################

COPY src/* /root/

# For cross compile on dockerhub
################################

COPY aarch64/qemu-aarch64-static /usr/bin/
COPY aarch64/resin-xbuild /usr/bin/

RUN [ "/usr/bin/qemu-aarch64-static", "/bin/sh", "-c", "ln -s resin-xbuild /usr/bin/cross-build-start; ln -s resin-xbuild /usr/bin/cross-build-end; ln /bin/sh /bin/sh.real" ]

RUN [ "cross-build-start" ]

# Create missing directories
############################

RUN mkdir -p $DATA_DIR

# Set the work directory
########################

WORKDIR /root

# Fix permissions
#################

RUN chmod 0644 * \
    && chmod 0755 *.sh

# Install required packages
##############################

RUN apk --update add --no-cache \
    bash \
    supervisor \
    pdns \
    pdns-doc \
    pdns-recursor \
    pdns-backend-sqlite3 \
    sqlite \
    curl \
    dbus \
    libldap \
    python3

# Required by PowerDNS Admin GUI
RUN apk --update add --no-cache --virtual .build-deps \
    git \
    gcc \
    musl-dev \
    python3-dev \
    mariadb-dev \
    libffi-dev \
    libxslt-dev \
    xmlsec-dev \
    openldap-dev \
    nodejs \
    npm

# Install PowerDNS Admin GUI
##############################

RUN mkdir -p /usr/share/webapps/ \
    && cd /usr/share/webapps/ \
    && git config --system http.sslverify false \
    && git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git powerdns-admin \
    && cd /usr/share/webapps/powerdns-admin \
    && pip3 install --no-cache-dir -r requirements.txt \
    && mv package.json app/static \
    && cd app/static \
    && npm i

# Cleanup
#########

RUN find /usr/local \
      \( -type d -a -name test -o -name tests \) \
      -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
      -exec rm -rf '{}' + \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

# Replace default configurations
################################
RUN rm /etc/pdns/pdns.conf \
    && rm /etc/pdns/recursor.conf \
    && rm /etc/supervisord.conf \
    && mv /root/pdns.conf /etc/pdns \
    && mv /root/recursor.conf /etc/pdns \
    && mv /root/config.py /usr/share/webapps/powerdns-admin \
    && mv /root/supervisord.conf /etc

# Allow redirection of stdout to docker logs
############################################
RUN ln -sf /proc/1/fd/1 /var/log/docker.log

# For cross compile on dockerhub
################################

RUN [ "cross-build-end" ]

# Expose required ports
#######################

EXPOSE 53
EXPOSE 53/udp
EXPOSE 8080

# Change Shell
##############
SHELL ["/bin/bash", "-c"]

# Set the entry point to init.sh
###########################################

ENTRYPOINT /root/init.sh
