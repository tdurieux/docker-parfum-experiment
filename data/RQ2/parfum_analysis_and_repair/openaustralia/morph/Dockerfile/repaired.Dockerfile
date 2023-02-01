FROM ruby:2.4.10
RUN mkdir /morph
WORKDIR /morph
# We need a javascript runtime
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
ADD Gemfile /morph/Gemfile
ADD Gemfile.lock /morph/Gemfile.lock
# TODO: Don't run as root
# TODO: Update bundler by running "gem install bundler"
RUN bundle install
ADD . /morph
