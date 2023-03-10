FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs redis-server libcurl3-dev && rm -rf /var/lib/apt/lists/*;

USER root

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler:2.3.9
RUN bundle
COPY . /myapp

CMD ["foreman", "start"]