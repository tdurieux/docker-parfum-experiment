FROM ruby:3.0

WORKDIR /usr/src/app
RUN git init

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

COPY Gemfile licensee.gemspec ./
COPY lib/licensee/version.rb ./lib/licensee/version.rb
RUN bundle install

COPY bin ./bin
COPY lib ./lib
COPY vendor ./vendor

ENTRYPOINT ["bundle", "exec", "./bin/licensee"]
