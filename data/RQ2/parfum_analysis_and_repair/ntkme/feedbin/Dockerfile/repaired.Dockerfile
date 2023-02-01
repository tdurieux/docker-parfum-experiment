FROM docker.io/library/ruby:2.7

COPY vendor/github.com /opt
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends libidn11-dev libvips42 nodejs postgresql-client \
 && rm -rf /var/lib/apt/lists/* \
 && gem update --system \
 && npm install -g yarn \
 && cd /opt/feedbin/feedbin \
 && bundle install \
 && cd /opt/feedbin/image \
 && bundle install \
 && cd /opt/feedbin/refresher \
 && bundle install \
 && cd /opt/feedbin/extract \
 && npm ci \
 && mkdir users && npm cache clean --force; && rm -rf /root/.gem;

WORKDIR /opt/feedbin/feedbin

CMD ["bundle", "exec", "foreman", "start"]
