FROM debian:buster-slim
RUN apt-get update \
    && apt-get install --no-install-recommends -y supervisor wget gnupg1 nginx-light \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://molior.info/archive-keyring.asc -q -O- | apt-key add -
COPY apt.sources /etc/apt/sources.list.d/molior.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y molior-server molior-web \
    && rm -rf /var/lib/apt/lists/*
RUN sed -i -e '/::/d' -e 's/localhost/molior/' /etc/nginx/sites-enabled/molior-web
RUN sed -i 's/127.0.0.1/molior/' /etc/molior/molior.yml
RUN sed -i 's/handlers=\[logging.handlers.SysLogHandler.*/)/' /usr/lib/python3/dist-packages/molior/app.py
RUN echo "daemon off;" >/etc/nginx/modules-enabled/no-daemon.conf
COPY molior-supervisord.conf /etc/supervisor/conf.d/molior.conf
COPY molior-start.sh /usr/local/bin/molior-start.sh
COPY postgres-start.sh /usr/local/bin/postgres-start.sh
COPY molior-nginx-start.sh /usr/local/bin/molior-nginx-start.sh
CMD /usr/bin/supervisord
