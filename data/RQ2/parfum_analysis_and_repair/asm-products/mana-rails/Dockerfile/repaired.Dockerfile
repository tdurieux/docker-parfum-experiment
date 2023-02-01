FROM ruby:2.2.1

RUN apt-get update && apt-get install --no-install-recommends -qq -y libicu-dev cmake nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir /mana-rails
WORKDIR /mana-rails

ADD Gemfile /mana-rails/Gemfile
ADD Gemfile.lock /mana-rails/Gemfile.lock
RUN bundle install

ADD . /mana-rails
