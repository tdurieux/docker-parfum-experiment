FROM ruby:2.5.1-slim
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs libsqlite3-dev \
    && apt-get clean autoclean \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app
CMD bundle exec rails s -p 3000 -b '0.0.0.0'
