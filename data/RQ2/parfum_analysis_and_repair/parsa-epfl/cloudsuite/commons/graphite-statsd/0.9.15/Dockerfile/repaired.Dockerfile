FROM cloudsuite/base-os:debian
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y apt-transport-https software-properties-common wget gnupg2 runit && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - \
    && echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y grafana && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y --no-install-recommends install nginx \
 python-dev \
 python-flup \
 python-pip \
 python-ldap \
 expect \
 git \
 memcached \
 sqlite3 \
 libcairo2 \
 libcairo2-dev \
 python-cairo \
 python-rrdtool \
 pkg-config \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install curl \
    && curl -f -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install --no-install-recommends -y nodejs=4.8.7-1nodesource1 && rm -rf /var/lib/apt/lists/*;

# python dependencies
RUN pip install --no-cache-dir django==1.5.12 \
 python-memcached==1.53 \
 django-tagging==0.3.1 \
 twisted==11.1.0 \
 txAMQP==0.6.2

# install graphite
RUN git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web
WORKDIR /usr/local/src/graphite-web
RUN python ./setup.py install

# install whisper
RUN git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/whisper.git /usr/local/src/whisper
WORKDIR /usr/local/src/whisper
RUN python ./setup.py install

# install carbon
RUN git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/carbon.git /usr/local/src/carbon
WORKDIR /usr/local/src/carbon
RUN python ./setup.py install

# install statsd
RUN git clone -b v0.8.0 https://github.com/etsy/statsd.git /opt/statsd

# config graphite
ADD conf/opt/graphite/conf/*.conf /opt/graphite/conf/
ADD conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD conf/opt/graphite/webapp/graphite/app_settings.py /opt/graphite/webapp/graphite/app_settings.py
RUN python /opt/graphite/webapp/graphite/manage.py collectstatic --noinput

# config statsd
ADD conf/opt/statsd/config_*.js /opt/statsd/

# config grafana
ADD conf/etc/grafana/grafana.ini /etc/grafana/grafana.ini

# config nginx
RUN rm /etc/nginx/sites-enabled/default
ADD conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/etc/nginx/sites-enabled/graphite-statsd.conf /etc/nginx/sites-enabled/graphite-statsd.conf
ADD conf/etc/nginx/sites-enabled/grafana.conf /etc/nginx/sites-enabled/grafana.conf

# init django admin
ADD conf/usr/local/bin/django_admin_init.exp /usr/local/bin/django_admin_init.exp
RUN /usr/local/bin/django_admin_init.exp

# logging support
RUN mkdir -p /var/log/carbon /var/log/graphite /var/log/nginx
ADD conf/etc/logrotate.d/graphite-statsd /etc/logrotate.d/graphite-statsd

# daemons
ADD conf/etc/service/carbon/run /etc/service/carbon/run
ADD conf/etc/service/carbon-aggregator/run /etc/service/carbon-aggregator/run
ADD conf/etc/service/graphite/run /etc/service/graphite/run
ADD conf/etc/service/statsd/run /etc/service/statsd/run
ADD conf/etc/service/grafana/run /etc/service/grafana/run
ADD conf/etc/service/nginx/run /etc/service/nginx/run

# default conf setup
ADD conf /etc/graphite-statsd/conf
ADD conf/etc/my_init.d/01_conf_init.sh /etc/my_init.d/01_conf_init.sh
ADD my_init /sbin/my_init
RUN chmod a+x /sbin/my_init
# cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# defaults
EXPOSE 80 2003-2004 2023-2024 8125 8125/udp 8126
VOLUME ["/opt/graphite/conf", "/opt/graphite/storage", "/etc/grafana", "/etc/nginx", "/opt/statsd", "/etc/logrotate.d", "/var/log"]
WORKDIR /
ENV HOME /root
ENV STATSD_INTERFACE udp

CMD ["/sbin/my_init"]
