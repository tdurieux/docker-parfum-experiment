ARG RUBY_TEST_VERSION
FROM ruby:$RUBY_TEST_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list



WORKDIR /bugsnag
COPY temp-bugsnag-lib ./

WORKDIR /usr/src/app
COPY app/Gemfile /usr/src/app/
RUN bundle install

RUN cat Gemfile.lock

COPY app/ /usr/src/app

RUN bundle exec rake db:migrate

RUN bundle exec rake app:update:bin

CMD ["bundle", "exec", "bin/rails", "s", "-b", "0.0.0.0"]
