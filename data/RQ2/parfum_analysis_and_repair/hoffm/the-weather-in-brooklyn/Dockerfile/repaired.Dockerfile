FROM ruby:3.1.2 AS base

RUN apt-get update && apt-get install --no-install-recommends \
    bc \
    sox \
    libsox-fmt-mp3 \
    --yes && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler:2.3.13

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without test development
RUN bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "bin/run.rb"]
