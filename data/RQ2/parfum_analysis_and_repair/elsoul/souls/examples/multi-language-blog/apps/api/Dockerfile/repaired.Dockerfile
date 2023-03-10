FROM ruby:3.0.3

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs redis-server && rm -rf /var/lib/apt/lists/*;

USER root

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler:2.2.32
RUN bundle
COPY . /myapp

CMD ["foreman", "start"]