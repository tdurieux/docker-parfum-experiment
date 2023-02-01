FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ADD Gemfile Gemfile.lock Rakefile ./

RUN bundle install

COPY . /app
