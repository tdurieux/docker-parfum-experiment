From ruby:2.3.1-slim
MAINTAINER Steve Ellis <steve@smartcontract.com>

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

# Bundler caching trick
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install -j 4

ENV APP_HOME /wei_watchers
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

CMD ["bundle", "exec", "foreman", "start"]
