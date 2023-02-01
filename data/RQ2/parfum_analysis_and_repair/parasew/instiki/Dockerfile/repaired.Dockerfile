FROM ruby:2.3
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    rake rubygems ruby-sqlite3 libxslt-dev libxml2-dev libsqlite3-dev swig flex bison \
    && rm -rf /var/lib/apt/lists/* && \
    gem update --system && gem update && rm -rf /root/.gem;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 2500

CMD ["./instiki"]
