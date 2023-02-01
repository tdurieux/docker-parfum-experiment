FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /code/
ADD . /code/
WORKDIR /code/
RUN bundle install
CMD [ "bundle","exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]
