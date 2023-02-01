FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /signupsumo
WORKDIR /signupsumo
ADD Gemfile /signupsumo/Gemfile
ADD Gemfile.lock /signupsumo/Gemfile.lock
RUN bundle install
ADD . /signupsumo
