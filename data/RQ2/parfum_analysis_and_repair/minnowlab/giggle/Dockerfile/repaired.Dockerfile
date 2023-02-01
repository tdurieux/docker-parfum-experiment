FROM ruby
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
RUN bundle install
ADD . /myapp
