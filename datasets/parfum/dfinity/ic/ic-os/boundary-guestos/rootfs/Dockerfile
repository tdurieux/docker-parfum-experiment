# BoundarGuestOS - Main Docker Image
#
# Build steps:
# - `docker build --pull -t dfinity/boundaryos-main -f Dockerfile .`
#
# The base images are defined in docker-base.prod and docker-base.dev. Update
# the references there when a new base image has been built. Note that this
# argument MUST be given by the build script, otherwise build will fail.
ARG BASE_IMAGE=

# Service worker verion and sha256
ARG sw_version=1.2.0
ARG sw_sha256=2f84ab0b02e3ac45b2c4de31789ccf7f6389887931970326842bfefb07073b55

# First build stage: download software, build and verify it (such that it
# does not change under our noses).
FROM ubuntu:20.04 AS download

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    pkg-config \
    libffi-dev \
    libssl-dev \
    ssl-cert \
    rustc \
    cargo \
    perl

WORKDIR /tmp

# Download and verify journalbeat
RUN \
    curl -L -O https://artifacts.elastic.co/downloads/beats/journalbeat/journalbeat-oss-7.14.0-linux-x86_64.tar.gz && \
    echo "3c97e8706bd0d2e30678beee7537b6fe6807cf858a0dd2e7cfce5beccb621eb0fefe6871027bc7b55e2ea98d7fe2ca03d4d92a7b264abbb0d6d54ecfa6f6a305  journalbeat-oss-7.14.0-linux-x86_64.tar.gz" | shasum -c

# Download and verify vector
RUN \
    curl -L -O https://packages.timber.io/vector/0.21.0/vector_0.21.0-1_amd64.deb && \
    echo "bd713a9e739cca53f9aa1e49e4abf0f0a3ba68a1c5f5f42106ed9b98282f2f06f009e0779c24368aea9d4e829af7614043ae9625dcc849717931c20a6812ede7  vector_0.21.0-1_amd64.deb" | shasum -c

# Download and verify node_exporter
RUN \
    curl -L -O https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz && \
    echo "68f3802c2dd3980667e4ba65ea2e1fb03f4a4ba026cca375f15a0390ff850949  node_exporter-1.3.1.linux-amd64.tar.gz" | shasum -c

# Download and verify nginx_exporter
RUN \
    curl -L -O https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.10.0/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz && \
    echo "30e664006dbc2d1185d3a5445942cd8158d1bb58  nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz" | shasum -c

# Download libnginx-mod-http-ndk.deb
RUN \
   curl -L -O https://github.com/dfinity/nginx-module-cbor-input/releases/download/v0.0.9/libnginx-mod-http-ndk_0.3.1_amd64.deb && \
   echo "6a496d8c7f3357fda9e5adeb7a729e76c453f32c6d67bc0ec563b0f71e2a0aca  libnginx-mod-http-ndk_0.3.1_amd64.deb" | shasum -c

# Download libnginx-mod-http-cbor-input.deb
RUN \
   curl -L -O https://github.com/dfinity/nginx-module-cbor-input/releases/download/v0.0.9/libnginx-mod-http-cbor-input_0.0.9_amd64.deb && \
   echo "8dca8fb93a6645c4aee23f601e9d9f62a00638ff29f95ceafcd10f422a3126f0  libnginx-mod-http-cbor-input_0.0.9_amd64.deb" | shasum -c

# Download icx-proxy.deb 
RUN \
    curl -L -O https://github.com/dfinity/icx-proxy/releases/download/rev-dcaa135/icx-proxy.deb && \
    echo "e20c7f6dcbe438ef9ec7dbff7d88d88db4099cb2b8d6dc399f47856baf0e568c  icx-proxy.deb" | shasum -c

# Download and check service worker
ARG sw_version
ARG sw_sha256
RUN \
   curl -L -O https://registry.npmjs.org/@dfinity/service-worker/-/service-worker-${sw_version}.tgz && \
   echo "${sw_sha256}  service-worker-${sw_version}.tgz" | shasum -c

#
# Second build stage:
# - Construct the actual target image (IC-OS root filesystem)
# - Copy downloaded archives from first build stage into the target image
#
FROM $BASE_IMAGE

RUN mkdir -p /boot/config \
             /boot/efi \
             /boot/grub
COPY etc /etc

# Update POSIX permissions in /etc/
RUN find /etc -type d -exec chmod 0755 {} \+ && \
    find /etc -type f -not -path "/etc/hostname" -not -path "/etc/hosts" -not -path "/etc/resolv.conf" -exec chmod 0644 {} \+ && \
    chmod 0755 /etc/systemd/system-generators/mount-generator && \
    chmod 0440 /etc/sudoers && \
    chmod 755 /etc/initramfs-tools/scripts/init-bottom/set-machine-id && \
    chmod 755 /etc/initramfs-tools/scripts/local && \
    chmod 755 /etc/initramfs-tools/scripts/local-premount/setup-verity && \
    chmod 755 /etc/initramfs-tools/hooks/setup-verity

# Deactivate motd, it tries creating $HOME/.cache/motd.legal-displayed,
# but we want to prohibit it from writing to user home dirs
RUN sed -e '/.*pam_motd.so.*/d' -i /etc/pam.d/login && \
    sed -e '/.*pam_motd.so.*/d' -i /etc/pam.d/sshd

# Deactivate lvm backup/archive: It writes backup information to /etc/lvm, but a) this is
# per system (so backups are not persisted across upgrades) and thus not very
# useful, and b) we want to turn /etc read-only eventually. So simply suppress
# generating backups.
RUN sed -e 's/\(backup *= *\)1/\10/' -e 's/\(archive *= *\)1/\10/' -i /etc/lvm/lvm.conf

# Deactivate systemd userdb. We don't use it.
RUN sed -e 's/ *systemd//' -i /etc/nsswitch.conf

# Regenerate initramfs (config changed after copying in /etc)
RUN RESUME=none update-initramfs -c -k all

ARG ROOT_PASSWORD=
RUN \
    if [ "${ROOT_PASSWORD}" != "" ]; then \
        echo "root:$(openssl passwd -6 -salt jE8zzDEHeRg/DuGq ${ROOT_PASSWORD})" | chpasswd -e ; \
    fi

# Prepare for bind mount of authorized_keys
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh

# Delete generated ssh keys, otherwise every host will have the same key pair.
# They will be generated on first boot.
RUN rm /etc/ssh/ssh*key*
# Allow root login only via keys. In prod deployments there are never any
# keys set up for root, but in dev deployments there may be.
# Actually, prohibit-password is the default config, so would not be
# strictly necessary to be explicit here.
RUN sed -e "s/.*PermitRootLogin.*/PermitRootLogin prohibit-password/" -i /etc/ssh/sshd_config

# All of the above sets up the base operating system. Everything below relates
# to node operation.

RUN \
    for SERVICE in /etc/systemd/system/*; do \
        if [ -f "$SERVICE" -a ! -L "$SERVICE" ] ; then systemctl enable "${SERVICE#/etc/systemd/system/}" ; fi ; \
    done

RUN systemctl enable \
    chrony \
    nftables \
    systemd-networkd \
    systemd-networkd-wait-online \
    systemd-resolved \
    systemd-journal-gatewayd

# Add user/group entries specified here: /usr/lib/sysusers.d/systemd.conf E.g., systemd-timesync/coredump
RUN faketime "1970-1-1 0" systemd-sysusers

# Set /bin/sh to point to /bin/bash instead of the default /bin/dash
RUN echo "set dash/sh false" | debconf-communicate && dpkg-reconfigure -fnoninteractive dash

# Group accounts to which parts of the runtime state are assigned such that
# user accounts can be granted individual access rights.
# Note that a group "backup" already exists and is used for the purpose of
# allowing backup read access.
RUN addgroup --system nonconfidential && \
    addgroup --system confidential

# Accounts to allow remote access to state bits

# The "backup" user account. We simply use the existing "backup" account and
# reconfigure it for our purposes.
RUN chsh -s /bin/bash backup && \
    mkdir /var/lib/backup && \
    chown backup:backup /var/lib/backup && \
    usermod -d /var/lib/backup backup && \
    adduser backup systemd-journal

# The "read-only" user account. May read everything besides crypto.
RUN adduser --system --disabled-password --home /var/lib/readonly --shell /bin/bash readonly && \
    adduser readonly backup && \
    adduser readonly nonconfidential && \
    adduser readonly systemd-journal

# The omnipotent "admin" account. May read everything and crucially can also
# arbitrarily change system state via sudo.
RUN adduser --system --disabled-password --home /var/lib/admin --shell /bin/bash admin && \
    chown admin:staff /var/lib/admin && \
    adduser admin backup && \
    adduser admin nonconfidential && \
    adduser admin systemd-journal && \
    adduser admin sudo

# The "journalbeat" account. Used to run journalbeat binary to send logs of the
# GuestOS.
RUN addgroup journalbeat && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "Journalbeat" journalbeat && \
    adduser journalbeat journalbeat && \
    adduser journalbeat systemd-journal

# The "vector" account. Used to run vector binary
RUN addgroup vector && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "Vector" vector && \
    adduser vector vector

# The "node_exporter" account. Used to run node_exporter binary to export
# telemetry metrics of the GuestOS.
RUN addgroup node_exporter && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "Node Exporter" node_exporter && \
    adduser node_exporter node_exporter

# The "socks" account for socks proxy
# Also set correct permissions for dante and stunnel.
# Stunnel4 cannot be started as a systemctl service so starting it as `stunnel4 start`
RUN addgroup socks && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "Socks" socks && \
    adduser socks socks && chmod +s /usr/sbin/danted && \
    chmod 0755 /etc/init.d/stunnel4

RUN \
    addgroup prober && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "Prober" prober && \
    adduser prober prober

RUN \
    mkdir -p /var/log/prober && \
    chown prober:prober /var/log/prober && \
    chmod 755 /var/log/prober

# Install journalbeat
COPY --from=download /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/journalbeat \
             /var/lib/journalbeat \
             /var/log/journalbeat && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/fields.yml && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat.reference.yml && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat && \
    chown root:root /etc/journalbeat/*.yml \
                    /usr/local/bin/journalbeat && \
    chown journalbeat:journalbeat /var/lib/journalbeat \
                                  /var/log/journalbeat && \
    chmod 0755 /etc/journalbeat && \
    chmod 0750 /var/lib/journalbeat \
               /var/log/journalbeat && \
    chmod 0644 /etc/journalbeat/*.yml && \
    rm /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz

# Install vector
COPY --from=download /tmp/vector_0.21.0-1_amd64.deb /tmp/vector_0.21.0-1_amd64.deb
RUN dpkg -i --force-confold /tmp/vector_0.21.0-1_amd64.deb && \
    rm /tmp/vector_0.21.0-1_amd64.deb

# Install node_exporter
COPY --from=download /tmp/node_exporter-1.3.1.linux-amd64.tar.gz /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/node_exporter && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf node_exporter-1.3.1.linux-amd64.tar.gz node_exporter-1.3.1.linux-amd64/node_exporter && \
    chown root:root /etc/node_exporter \
                    /usr/local/bin/node_exporter && \
    chmod 0755 /etc/node_exporter \
               /usr/local/bin/node_exporter && \
    chmod 0644 /etc/default/node_exporter \
               /etc/node_exporter/web.yml && \
    rm /tmp/node_exporter-1.3.1.linux-amd64.tar.gz

# install nginx_exporter
RUN \
    addgroup nginx_exporter && \
    adduser --system --disabled-password --shell /usr/sbin/nologin -c "nginx_exporter" nginx_exporter && \
    adduser nginx_exporter nginx_exporter

COPY --from=download /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz
RUN \
    tar \
        -C /usr/local/bin \
        -zvxf /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz \
        nginx-prometheus-exporter && \
    mv \
        /usr/local/bin/nginx-prometheus-exporter \
        /usr/local/bin/nginx_exporter && \
    chown \
        nginx_exporter:nginx_exporter \
        /usr/local/bin/nginx_exporter && \
    rm /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz

# Install IC binaries and other data late -- this means everything above
# will be cached when only the binaries change.
COPY opt /opt

RUN rm -rf /etc/nginx/sites-enabled/nginx.conf

# Install libnginx-mod-http-ndk 
COPY --from=download /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb /tmp/
RUN dpkg -i /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb &&\
    rm /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb

# Install libnginx-mod-http-cbor-input
COPY --from=download /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb
RUN dpkg -i /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb &&\
    rm /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb

# Install icx-proxy
COPY --from=download /tmp/icx-proxy.deb /tmp/icx-proxy.deb
RUN dpkg -i /tmp/icx-proxy.deb &&\
    rm /tmp/icx-proxy.deb

# Install ic service worker production version from: https://registry.npmjs.org/@dfinity/service-worker/-/
ARG sw_version
COPY --from=download /tmp/service-worker-${sw_version}.tgz /tmp/service-worker-${sw_version}.tgz
RUN cd /tmp && tar xfvz service-worker-${sw_version}.tgz && \
    mkdir -p /var/www/html/ &&\
    cp -rf /tmp/package/dist-prod/* /var/www/html/ &&\
    rm -rf /tmp/package /tmp/service-worker-${sw_version}.tgz
RUN chown www-data:www-data /var/www/html && \
    chmod 0755 /var/www/html/*
# Install other files (e.g. the uninstall-script)
COPY var/www/html /var/www/html

# Clear all files that may lead to indeterministic build.
RUN apt-get clean && \
    rm -rf \
        /var/cache/fontconfig/* /var/cache/ldconfig/aux-cache \
        /var/log/alternatives.log /var/log/apt/history.log /var/log/apt/term.log /var/log/dpkg.log \
        /var/lib/apt/lists/* /var/lib/dbus/machine-id \
        /var/lib/initramfs-tools/5.8.0-50-generic && \
    find /usr/local/share/fonts -name .uuid | xargs rm && \
    find /usr/share/fonts -name .uuid | xargs rm && \
    find /usr/lib -name "*.pyc" | xargs rm -rf&& \
    find /usr/share -name "*.pyc" | xargs rm -rf&& \
    truncate --size 0 /etc/machine-id

# Update POSIX permissions in /opt/ic/
RUN find /opt -type d -exec chmod 0755 {} \+ && \
    find /opt -type f -exec chmod 0644 {} \+ && \
    chmod 0755 /opt/ic/bin/*

COPY boot /boot
# Update POSIX permissions in /boot/
RUN chmod 0644 /boot/extra_boot_args



# CERTIFICATES
# Default image has
# 1. fullchain.pem: self signed certificates from the ssl-cert package.
# 2. privkey.pem: key for the self signed certificate.
# 3. chain.pem: Dummy certficate of the issuer for OCSP stapling to work.
#    This cert is irrelevant because the certificate is self signed.
#
# Prod image
#
# Has the above 3 certificates in /boot/config/cert. The setup-nginx service
# copies over the certificates in the correct location to match the nginx conf
# file
#
# The naming convetion is the same a certificates generated by certbot renew
RUN mkdir -p /etc/nginx/certs
RUN mkdir -p /etc/nginx/keys
RUN cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/nginx/certs/fullchain.pem
RUN cp /etc/ssl/private/ssl-cert-snakeoil.key /etc/nginx/keys/privkey.pem
RUN cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/nginx/certs/chain.pem


# trusted_cert.pem contains all certificates for the upstream replica. This file
# is periodically updated by the proxy+watcher service. To bootstrap the process
# we initially place a dummy trusted cert. This dummy is the copy of the
# snakeoil cert. This allows the nginx service to start, but upstream routing
# will only happen once the control plane pulls the initial set of routes
#
RUN cp /etc/nginx/certs/fullchain.pem /etc/nginx/ic/trusted_certs.pem

# Take care of nginx files
RUN chmod 0755 /etc/nginx/*
RUN chmod 0644 /etc/nginx/ic_public_key.pem
RUN chmod 0644 /etc/nginx/nginx.conf
RUN chmod 0644 /etc/nginx/modules-enabled/ngx_http_cbor_input_module.conf
RUN chmod 0644 /etc/nginx/modules-enabled/ngx_http_js_module.conf
RUN chmod 0755 /etc/nginx/ic/ic_router_control_plane_watcher.sh
RUN rm -rf /etc/nginx/conf.d/nginx-global.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
RUN rm -rf /etc/nginx/sites-enabled/default
RUN rm -rf /etc/nginx/conf.d/default
