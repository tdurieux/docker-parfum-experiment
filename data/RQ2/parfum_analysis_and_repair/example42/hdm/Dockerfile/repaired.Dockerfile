FROM ruby:2.5.8

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y build-essential npm nodejs yarn && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler -v 2.2.15

ENV APP_HOME /hdm
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/
RUN bundle config set --local path 'vendor/bundle' && bundle install

COPY . $APP_HOME
COPY config/hdm.yml.template $APP_HOME/config/hdm.yml

RUN yarn install --check-files && yarn cache clean;

EXPOSE 3000

CMD ["/hdm/bin/entry.sh"]
