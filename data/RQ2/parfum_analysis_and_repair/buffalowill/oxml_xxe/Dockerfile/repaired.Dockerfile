FROM ruby:2.3.8-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y make git libsqlite3-dev libxslt-dev libxml2-dev zlib1g-dev gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /oxml_xxe

# install deps
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4567
CMD ruby server.rb -o 0.0.0.0 -p 4567
