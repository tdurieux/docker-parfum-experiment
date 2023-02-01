FROM whatupdave/ruby:2.1.5

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
