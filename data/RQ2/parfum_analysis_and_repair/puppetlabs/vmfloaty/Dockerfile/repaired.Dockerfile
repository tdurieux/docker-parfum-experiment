FROM ruby:3.1.1-slim-buster

COPY ./ ./

RUN apt-get update && apt-get install --no-install-recommends -y less && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler && bundle install && gem build vmfloaty.gemspec && gem install vmfloaty*.gem
