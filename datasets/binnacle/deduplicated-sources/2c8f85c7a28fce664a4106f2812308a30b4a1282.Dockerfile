FROM ubuntu:16.04

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        wget mysql-client supervisor nginx crudini ffmpeg python-pip \
        python2.7 libpython2.7 python-setuptools python-imaging python-sqlalchemy \
        python-ldap python-mysqldb python-pylibmc python-urllib3 && \
    pip install pillow moviepy django-pylibmc && \
    apt-get remove -y --purge --autoremove python-pip && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/nginx/sites-enabled/*

ENV SEAFILE_VERSION 7.0.2
ENV SEAFILE_PATH "/opt/seafile/$SEAFILE_VERSION"

RUN \
    mkdir -p /seafile "${SEAFILE_PATH}" && \
    wget --progress=dot:mega --no-check-certificate -O /tmp/seafile-server.tar.gz \
        "https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz" && \
    tar -xzf /tmp/seafile-server.tar.gz --strip-components=1 -C "${SEAFILE_PATH}" && \
    sed -ie '/^daemon/d' "${SEAFILE_PATH}/runtime/seahub.conf" && \
    rm /tmp/seafile-server.tar.gz

COPY etc/ /etc/
COPY scripts/ /scripts/

RUN \
    chmod +x /scripts/*.sh && \
    mkdir -p /run/seafile && \
    ln -s /run/seafile /opt/seafile/pids && \
    ln -s "${SEAFILE_PATH}" /opt/seafile/latest && \
    ln -s /etc/nginx/sites-available/seafile.conf /etc/nginx/sites-enabled/seafile.conf && \
    mkdir -p /seafile && \
    # seafile user
    useradd -r -s /bin/false seafile && \
    chown seafile:seafile /run/seafile

WORKDIR "/seafile"

VOLUME "/seafile"

EXPOSE 80

CMD ["/scripts/startup.sh"]
