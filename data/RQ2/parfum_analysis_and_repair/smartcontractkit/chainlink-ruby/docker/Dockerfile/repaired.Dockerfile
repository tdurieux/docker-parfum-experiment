From ruby:2.3.5-slim
MAINTAINER Steve Ellis <steve@smartcontract.com>

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs && rm -rf /var/lib/apt/lists/*;
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
run gem update --system 2.6.1 --no-document && rm -rf /root/.gem;
RUN gem install bundler

# Bundler caching trick
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install -j 4 --without test development
RUN HOSTIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

ENV APP_HOME /nayru
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

ENTRYPOINT ["bundle", "exec"]

CMD ["foreman", "start"]
