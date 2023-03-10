FROM ruby:2.7

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY . /usr/src/app
RUN bundle install

CMD ["bundle", "exec", "rspec"]

