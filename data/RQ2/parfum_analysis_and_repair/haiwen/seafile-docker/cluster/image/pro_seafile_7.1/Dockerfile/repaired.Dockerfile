# See https://hub.docker.com/r/phusion/baseimage/tags/
FROM phusion/baseimage:0.11
ENV SEAFILE_SERVER=seafile-pro-server SEAFILE_VERSION=

RUN apt-get update --fix-missing

# Utility tools
RUN apt-get install --no-install-recommends -y vim htop net-tools psmisc wget curl git && rm -rf /var/lib/apt/lists/*;

# For suport set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install --no-install-recommends tzdata -y && rm -rf /var/lib/apt/lists/*;

# Nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Java
RUN apt-get install --no-install-recommends -y openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

# Libreoffice
RUN apt-get install --no-install-recommends -y libreoffice libreoffice-script-provider-python libsm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && rm -rf /var/lib/apt/lists/*;

# Tools
RUN apt-get install --no-install-recommends -y zlib1g-dev pwgen openssl poppler-utils && rm -rf /var/lib/apt/lists/*;


# Python3
RUN apt-get install --no-install-recommends -y python3 python3-pip python3-setuptools python3-ldap python-rados && rm -rf /var/lib/apt/lists/*;
RUN python3.6 -m pip install --upgrade pip && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 click termcolor colorlog pymysql \
    django==1.11.29 && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 Pillow pylibmc captcha jinja2 \
    sqlalchemy django-pylibmc django-simple-captcha && \
    rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 boto oss2 pycryptodome twilio python-ldap configparser && \
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
    wget -O seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz \
    "https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz&dl=1" && \
    tar -zxvf seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz && \
    rm -f seafile-pro-server_${SEAFILE_VERSION}_x86-64_Ubuntu.tar.gz


EXPOSE 80


CMD ["/sbin/my_init", "--", "/scripts/enterpoint.sh"]
