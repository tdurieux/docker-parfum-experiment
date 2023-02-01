FROM debian:buster-slim
RUN apt-get update \
    && apt-get install --no-install-recommends -y supervisor wget gnupg1 nginx-light \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://molior.info/archive-keyring.asc -q -O- | apt-key add -
COPY apt.sources /etc/apt/sources.list.d/molior.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y aptly apg apache2-utils \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/listen 80\([^0-9]\)/listen 8080\1/' /etc/nginx/sites-enabled/aptlyapi
RUN sed -i 's/listen 80/listen 3142/' /etc/nginx/sites-enabled/aptly
RUN echo "daemon off;" >/etc/nginx/modules-enabled/no-daemon.conf
COPY aptly-supervisord.conf /etc/supervisor/conf.d/aptly.conf
COPY aptly-start.sh /usr/local/bin/aptly-start.sh
COPY aptly-nginx-start.sh /usr/local/bin/aptly-nginx-start.sh
CMD /usr/bin/supervisord
