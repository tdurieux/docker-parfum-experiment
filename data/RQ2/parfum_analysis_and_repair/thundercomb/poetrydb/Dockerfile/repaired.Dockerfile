FROM ruby:2.6.0
RUN apt-get update && apt-get install --no-install-recommends -y mongodb-clients && rm -rf /var/lib/apt/lists/*;

RUN mkdir /poetrydb
COPY ./ /poetrydb
WORKDIR /poetrydb/app
RUN bundle install
