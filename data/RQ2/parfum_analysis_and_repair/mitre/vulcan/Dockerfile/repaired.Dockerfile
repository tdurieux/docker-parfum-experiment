FROM ruby:2.7

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs yarn && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /app
ENV RAILS_ENV production
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.2.32
ADD Gemfile* $APP_HOME/
RUN bundle install --without development test

ADD . $APP_HOME
RUN yarn install --check-files --production && yarn cache clean;
RUN SECRET_KEY_BASE=none NODE_ENV=production bundle exec rake assets:precompile
CMD ["rails","server","-b","0.0.0.0"]
