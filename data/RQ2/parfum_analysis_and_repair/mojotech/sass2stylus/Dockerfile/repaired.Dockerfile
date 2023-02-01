FROM ruby:2.4.9

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update -qq && apt-get install --no-install-recommends -yq build-essential nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN bundle install
