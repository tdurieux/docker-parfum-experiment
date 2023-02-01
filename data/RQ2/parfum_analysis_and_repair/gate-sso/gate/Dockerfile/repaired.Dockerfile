FROM ruby:2.4

RUN apt-get update
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

RUN gem install bundler -v '>= 2.0'
RUN bundle install --without development
COPY . /app

CMD [ "bundle", "exec", "rails", "s" ]
