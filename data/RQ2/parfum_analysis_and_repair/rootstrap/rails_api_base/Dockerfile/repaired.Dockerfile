FROM ruby:2.7.2

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libssl-dev nodejs libpq-dev less vim nano libsasl2-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

ENV WORK_ROOT /src
ENV APP_HOME $WORK_ROOT/myapp/
ENV LANG C.UTF-8
ENV GEM_HOME $WORK_ROOT/bundle
ENV BUNDLE_BIN $GEM_HOME/gems/bin
ENV PATH $GEM_HOME/bin:$BUNDLE_BIN:$PATH

RUN gem install bundler

RUN mkdir -p $APP_HOME

RUN bundle config --path=$GEM_HOME

WORKDIR $APP_HOME

ADD Gemfile ./
ADD Gemfile.lock ./
RUN bundle install

ADD package.json yarn.lock ./
RUN yarn install --check-files && yarn cache clean;

ADD . $APP_HOME

EXPOSE 3000

ENTRYPOINT bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"
