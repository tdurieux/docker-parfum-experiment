FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /manifesto
WORKDIR /manifesto
ADD Gemfile /manifesto/Gemfile
ADD Gemfile.lock /manifesto/Gemfile.lock
RUN bundle install
ADD . /manifesto
