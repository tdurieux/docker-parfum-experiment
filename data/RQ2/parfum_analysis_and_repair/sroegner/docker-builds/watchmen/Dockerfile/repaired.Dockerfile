FROM sroegner/centos-base-ssh

RUN yum -y install nodejs npm git redis; rm -rf /var/cache/yum \
    git clone https://github.com/iloire/WatchMen.git /srv/watchmen && \
    cd /srv/watchmen && npm install && mv config config.dist; npm cache clean --force; \
    mkdir -p /var/log/watchmen

ADD . /config
RUN cp -v /config/supervisord-watchmen.conf /etc/supervisor/conf.d/; \
    cp -v /config/supervisord-redis.conf /etc/supervisor/conf.d/; \
    cp -v /config/redis.conf /etc/redis.conf

VOLUME /srv/watchmen/config
EXPOSE 22 80 3000

CMD ["/usr/bin/supervisord", "-n"]
