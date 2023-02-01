FROM ruby:2.7-slim

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential ruby-dev && rm -rf /var/lib/apt/lists/*;

COPY docs /docs

WORKDIR /docs

RUN bundle install

EXPOSE 4000 80
CMD bundle exec jekyll serve --watch -H 0.0.0.0 -P 4000