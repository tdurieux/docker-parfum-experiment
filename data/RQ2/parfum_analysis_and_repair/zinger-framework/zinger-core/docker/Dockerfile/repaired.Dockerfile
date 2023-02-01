FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN mkdir /zinger
WORKDIR /zinger
ADD . /zinger
RUN bundle install
