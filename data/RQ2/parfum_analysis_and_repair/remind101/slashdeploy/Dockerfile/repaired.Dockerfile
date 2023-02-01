FROM ruby:2.6.7

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential openssl libssl-dev libpq-dev postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

WORKDIR /home/app

COPY Gemfile Gemfile.lock /home/app/
RUN bundle install --jobs 4 --retry 3

COPY . /home/app

CMD ["bundle", "exec", "rake"]
