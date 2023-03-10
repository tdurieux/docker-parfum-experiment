# Lastet phusion baseimage as of 20180412, based on ubuntu 18.04
# See https://hub.docker.com/r/phusion/baseimage/tags/
FROM phusion/baseimage:0.11

ENV UPDATED_AT=20180412 \
    DEBIAN_FRONTEND=noninteractive

CMD ["/sbin/my_init", "--", "bash", "-l"]

RUN apt-get update -qq && apt-get -qq --no-install-recommends -y install nginx tzdata && rm -rf /var/lib/apt/lists/*;

# Utility tools
RUN apt-get install --no-install-recommends -qq -y vim htop net-tools psmisc git wget curl && rm -rf /var/lib/apt/lists/*;

# Guidline for installing python libs: if a lib has C-compoment (e.g.
# python-imaging depends on libjpeg/libpng), we install it use apt-get.
# Otherwise we install it with pip.
RUN apt-get install --no-install-recommends -y python2.7-dev python-ldap python-mysqldb libmemcached-dev zlib1g-dev gcc && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    rm -rf /tmp/get-pip.py && \
    pip install --no-cache-dir -U wheel

ADD requirements.txt  /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY services /services

RUN mkdir -p /etc/service/nginx && \
    rm -f /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* && \
    mv /services/nginx.conf /etc/nginx/nginx.conf && \
    mv /services/nginx.sh /etc/service/nginx/run

RUN mkdir -p /etc/my_init.d && rm -f /etc/my_init.d/00_regen_ssh_host_keys.sh

# Clean up for docker squash
# See https://github.com/goldmann/docker-squash
RUN rm -rf \
    /root/.cache \
    /root/.npm \
    /root/.pip \
    /usr/local/share/doc \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/vim/vim74/doc \
    /usr/share/vim/vim74/lang \
    /usr/share/vim/vim74/spell/en* \
    /usr/share/vim/vim74/tutor \
    /var/lib/apt/lists/* \
    /tmp/*
