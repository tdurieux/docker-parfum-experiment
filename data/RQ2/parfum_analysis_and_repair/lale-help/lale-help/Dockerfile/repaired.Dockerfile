FROM ruby:2.2.3
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
ADD . /myapp
RUN bundle install --jobs 4
RUN echo foo