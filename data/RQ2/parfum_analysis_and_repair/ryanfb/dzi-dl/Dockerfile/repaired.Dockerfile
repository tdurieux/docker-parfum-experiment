FROM ruby:latest

RUN apt-get update && apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["/usr/src/app/dzi-dl.rb"]
