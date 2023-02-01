FROM ruby:3.0.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client cmake npm && rm -rf /var/lib/apt/lists/*;

RUN mkdir /var/app

WORKDIR /var/app

COPY Gemfile .
COPY Gemfile.lock .
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && gem install bundler && rm -rf /root/.gem;
RUN bundle install --jobs 4
RUN bundle exec rails db:setup RAILS_ENV=development

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
