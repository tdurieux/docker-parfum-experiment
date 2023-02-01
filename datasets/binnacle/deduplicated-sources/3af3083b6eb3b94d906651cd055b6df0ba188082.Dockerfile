FROM ruby:2.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY . /usr/src/app
RUN bundle install

CMD ["bundle", "exec", "rspec"]

