FROM ruby:2.7.0-slim-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y git vim build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*
   RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system 3.1.2 && \
    gem install bundler -v '2.1.2' && rm -rf /root/.gem;


WORKDIR /usr/src/app/alpha-blog

COPY . .

ENV BUNDLER_VERSION 2.1.2

RUN bundle update &&\
    bundle install &&\
    rails db:setup &&\
    rails db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]  
