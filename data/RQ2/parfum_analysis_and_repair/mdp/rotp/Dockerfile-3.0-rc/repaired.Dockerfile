FROM ruby:3.0-rc

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY . /usr/src/app
RUN gem install bundler
RUN bundle install

CMD ["bundle", "exec", "rspec"]

