FROM ruby:2.7.2-alpine

MAINTAINER BlueDoc "https://github.com/thebluedoc"
RUN gem install bundler
RUN apk --update --no-cache add ca-certificates tzdata imagemagick git curl zip redis postgresql postgresql-contrib \
    openssl nginx graphviz nodejs python2 && \
    apk add --no-cache --virtual .builddeps build-base yarn ruby-dev libc-dev linux-headers postgresql-dev \
    libxml2-dev libxslt-dev && \
    rm /etc/nginx/conf.d/default.conf

# Add Dockerize
RUN curl -f -sSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz -o dockerize-alpine-linux-amd64-v0.6.1.tar.gz && \
    tar zxf dockerize-alpine-linux-amd64-v0.6.1.tar.gz && \
    mv dockerize /usr/local/bin/ && rm dockerize-alpine-linux-amd64-v0.6.1.tar.gz

# Add ElasticSearch
RUN apk add --no-cache openjdk8-jre bash su-exec
ENV ES_VERSION "6.5.2"
ENV ES_TARBAL "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}.tar.gz"
RUN set -ex \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && curl -f -o elasticsearch.tar.gz "$ES_TARBAL"; \
  tar -xf elasticsearch.tar.gz \
  && mv elasticsearch-$ES_VERSION /usr/share/elasticsearch \
  && adduser -D -h /usr/share/elasticsearch elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
  /usr/share/elasticsearch/data \
  /usr/share/elasticsearch/logs \
  /usr/share/elasticsearch/config \
  /usr/share/elasticsearch/config/scripts \
  /usr/share/elasticsearch/tmp \
  /usr/share/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  chown -R elasticsearch:elasticsearch "$path"; \
  done \
  && rm -rf /tmp/* && rm elasticsearch.tar.gz

ENV ES_TMPDIR /usr/share/elasticsearch/tmp
ENV PATH /usr/share/elasticsearch/bin:$PATH

# Add wkhtmltopdf
RUN apk add --no-cache xvfb font-noto freetype fontconfig dbus qt5-qtwebkit && \
    apk add wkhtmltopdf --no-cache \
            --repository https://mirrors.ustc.edu.cn/alpine/edge/community/ \
            --allow-untrusted
# Add Monaco Font
RUN wget https://github.com/todylu/monaco.ttf/raw/master/monaco.ttf && \
    mkdir -p /usr/share/fonts/monaco && \
    mv monaco.ttf /usr/share/fonts/monaco && \
    fc-cache -f && \
    rm /usr/bin/wkhtmltoimage

# Add wqy-zenhei font
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk add --no-cache wqy-zenhei@edge && \
    apk add --no-cache wqy-zenhei --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing --allow-untrusted

# Add plantuml-service
RUN curl -f -L -o /usr/local/plantuml-service.jar https://github.com/bitjourney/plantuml-service/releases/download/v1.3.5/plantuml-service.jar
RUN curl -f -L -o mathjax-service-master.zip https://github.com/ruby-china/homeland/files/2732083/mathjax-service-master.zip && \
    unzip -q mathjax-service-master.zip -d /tmp && \
    mkdir -p /home/app && mv /tmp/mathjax-service-master /home/app/mathjax-service && \
    rm mathjax-service-master.zip && \
    cd /home/app/mathjax-service && \
    yarn && yarn cache clean;

# Add CaddyServer
RUN curl -f -o /usr/bin/caddy https://l.ruby-china.com/downloads/caddy_linux_amd64 && \
    chmod +x /usr/bin/caddy && \
    /usr/bin/caddy version