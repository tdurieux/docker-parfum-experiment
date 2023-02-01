FROM ruby:2.2.7

RUN apt-get update && apt-get install --no-install-recommends -y nodejs build-essential qt5-default libqt5webkit5-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

RUN gem install rb-readline

CMD ["foreman", "start"]
