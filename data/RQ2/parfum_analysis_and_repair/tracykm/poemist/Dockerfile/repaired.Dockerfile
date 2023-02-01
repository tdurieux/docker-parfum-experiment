FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev netcat && rm -rf /var/lib/apt/lists/*;
WORKDIR usr/src
COPY Gemfile* ./
RUN bundle install
COPY . .
CMD ./entrypoint.sh
