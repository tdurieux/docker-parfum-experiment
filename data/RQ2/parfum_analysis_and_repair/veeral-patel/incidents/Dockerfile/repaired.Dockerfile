FROM ruby:2.6.1

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
RUN rails assets:precompile

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
