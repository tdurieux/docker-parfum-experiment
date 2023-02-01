FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir /srv/share-brew
WORKDIR /srv/share-brew
ADD Gemfile /srv/share-brew/Gemfile
ADD Gemfile.lock /srv/share-brew/Gemfile.lock
RUN bundle install
ADD . /srv/share-brew
