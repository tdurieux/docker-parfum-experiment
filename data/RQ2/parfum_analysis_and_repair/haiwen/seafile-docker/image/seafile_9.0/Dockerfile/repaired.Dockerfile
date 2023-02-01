# See https://hub.docker.com/r/phusion/baseimage/tags/
FROM phusion/baseimage:focal-1.0.0
ENV SEAFILE_SERVER=seafile-server SEAFILE_VERSION=

RUN apt-get update --fix-missing

# Utility tools
RUN apt-get install --no-install-recommends -y vim htop net-tools psmisc wget curl git unzip && rm -rf /var/lib/apt/lists/*;

# For suport set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install --no-install-recommends tzdata -y && rm -rf /var/lib/apt/lists/*;

# Nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Mysqlclient
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

# Memcache
RUN apt-get install --no-install-recommends -y libmemcached11 libmemcached-dev && rm -rf /var/lib/apt/lists/*;

# Fuse
RUN apt-get install --no-install-recommends -y fuse && rm -rf /var/lib/apt/lists/*;

# Ldap
RUN apt-get install --no-install-recommends -y ldap-utils ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf

# Python3
RUN apt-get install --no-install-recommends -y python3 python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 click termcolor colorlog pymysql \
    django==3.2.* -i https://mirrors.aliyun.com/pypi/simple && rm -r /root/.cache/pip

RUN pip3 install --no-cache-dir --timeout=3600 future mysqlclient Pillow pylibmc captcha markupsafe==2.0.1 jinja2 \
    sqlalchemy django-pylibmc django-simple-captcha pyjwt pycryptodome==3.12.0 -i https://mirrors.aliyun.com/pypi/simple && \
    rm -r /root/.cache/pip


# Scripts
COPY scripts_9.0 /scripts

# acme
# RUN curl https://get.acme.sh | sh -s
RUN unzip /scripts/acme.sh-master.zip -d /scripts/ && \
    mv /scripts/acme.sh-master /scripts/acme.sh && \
    cd /scripts/acme.sh && /scripts/acme.sh/acme.sh --install

COPY templates /templates
COPY services /services
RUN chmod u+x /scripts/* && rm /scripts/cluster*

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
    wget https://seafile-downloads.oss-cn-shanghai.aliyuncs.com/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz && \
    tar -zxvf seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz && \
    rm -f seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz

# For using TLS connection to LDAP/AD server with docker-ce.
RUN find /opt/seafile/ \( -name "liblber-*" -o -name "libldap-*" -o -name "libldap_r*" -o -name "libsasl2.so*" -o -name "libcrypt.so.1" \) -delete


EXPOSE 80


CMD ["/sbin/my_init", "--", "/scripts/enterpoint.sh"]
