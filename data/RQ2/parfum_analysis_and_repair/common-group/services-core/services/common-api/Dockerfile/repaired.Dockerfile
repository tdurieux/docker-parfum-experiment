FROM library/ruby:2.5.1-alpine
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN set -x \
  && apk upgrade --no-cache \
  && apk add --no-cache --virtual build-dependencies \
    build-base libc-dev linux-headers tzdata\
    postgresql-dev postgresql-client openssl git \
  && apk add --no-cache \
    libxml2-dev \
    libxslt-dev \
  && gem update --system \
  && gem install nokogiri \
    -- --use-system-libraries \
    --with-xml2-config=/usr/bin/xml2-config \
    --with-xslt-config=/usr/bin/xslt-config && rm -rf /root/.gem;

RUN gem install bundler -v 2.2.27
ENV BUNDLER_VERSION=2.2.27

WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app
COPY . /app

RUN bundle install
