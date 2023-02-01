FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential libpq-dev nodejs \
  && apt-get clean autoclean autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

ADD Gemfile* /app/
RUN bundle install

ADD . /app/

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
