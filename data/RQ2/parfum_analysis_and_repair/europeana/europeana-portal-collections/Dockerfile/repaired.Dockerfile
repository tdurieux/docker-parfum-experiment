FROM ruby:2.6.0-slim

MAINTAINER Europeana Foundation <development@europeana.eu>

RUN apt-get update && apt-get install --no-install-recommends -q -y build-essential nodejs libpq-dev git libcurl3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["bundle", "exec", "puma"]
CMD ["-C", "config/puma.rb", "-v"]
