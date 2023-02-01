FROM eu.gcr.io/soundbadger-management/songkick-ruby:2.6

RUN apt-get update && apt-get -y --no-install-recommends install libxslt-dev libxml2-dev && rm -rf /var/lib/apt/lists/*;

COPY Gemfile* /app/
COPY songkick-transport.gemspec /app/
RUN bundle install

COPY . /app/

RUN mkdir -p log
