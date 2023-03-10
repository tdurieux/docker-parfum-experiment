ARG RUBY_TEST_VERSION
FROM ruby:$RUBY_TEST_VERSION

WORKDIR /bugsnag
COPY temp-bugsnag-lib ./

WORKDIR /usr/src/app
COPY app/Gemfile /usr/src/app/
RUN bundle install

COPY app/ /usr/src/app

RUN bundle exec rake db:migrate

RUN bundle exec rake rails:update:bin

CMD ["bundle", "exec", "bin/rails", "s", "-b", "0.0.0.0"]