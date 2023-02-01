FROM ruby:2.5

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /jobbyjobjob
WORKDIR /jobbyjobjob

COPY Gemfile /jobbyjobjob/Gemfile
COPY Gemfile.lock /jobbyjobjob/Gemfile.lock

RUN bundle install

COPY . /jobbyjobjob
