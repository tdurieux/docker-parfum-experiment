# See https://hub.docker.com/r/phusion/baseimage/tags/
FROM phusion/baseimage:0.11
ENV SEAFILE_SERVER=seafile-server SEAFILE_VERSION=

RUN apt-get update --fix-missing

# Utility tools
RUN apt-get install --no-install-recommends -y vim htop net-tools psmisc wget curl git && rm -rf /var/lib/apt/lists/*;

# For suport set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install --no-install-recommends tzdata -y && rm -rf /var/lib/apt/lists/*;

# Nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Python3
RUN apt-get install --no-install-recommends -y python3 python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN python3.6 -m pip install --upgrade pip && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 click termcolor colorlog pymysql \
    django==1.11.29 && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 Pillow pylibmc captcha jinja2 \
    sqlalchemy django-pylibmc django-simple-captcha && \
    rm -r /root/.cache/pip


# Scripts
COPY scripts_7.1 /scripts
COPY templates /templates
COPY services /services
RUN chmod u+x /scripts/*

RUN mkdir -p /etc/my_init.d && \
    rm -f /etc/my_init.d/* && \
    cp /scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

RUN mkdir -p /etc/service/nginx && \
    rm -f /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* && \
    mv /services/nginx.conf /etc/nginx/nginx.conf && \
    mv /services/nginx.sh /etc/service/nginx/run


# Seafile
WORKDIR /opt/seafile

RUN mkdir -p /opt/seafile/ && cd /opt/seafile/ && \
    wget https://download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz && \
    tar -zxvf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz && \
    rm -f seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz

# For using TLS connection to LDAP/AD server with docker-ce.
RUN find /opt/seafile/ \( -name "liblber-*" -o -name "libldap-*" -o -name "libldap_r*" -o -name "libsasl2.so*" \) -delete


EXPOSE 80


CMD ["/sbin/my_init", "--", "/scripts/start.py"]
