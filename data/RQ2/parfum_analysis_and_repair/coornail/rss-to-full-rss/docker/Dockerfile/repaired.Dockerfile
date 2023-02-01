FROM dockerfile/nodejs

EXPOSE 8000:8000

RUN apt-get update &&\
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y git memcached supervisor && \
  apt-get clean && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/*;

RUN npm install rss-fulltext && npm cache clean --force;

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord"]
