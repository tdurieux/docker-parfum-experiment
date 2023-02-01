FROM ruby:2.5.1

RUN apt-get update && \
    apt-get install --no-install-recommends -y git vim && \
    rm -rf /var/lib/apt/lists/*
   RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system 3.0.4 && \
    gem install bundler -v '2.0.2' && rm -rf /root/.gem;


WORKDIR /usr/src/app/alpha-blog

COPY . .

ENV BUNDLER_VERSION 2.0.2

RUN bundle update &&\
    bundle install &&\
    rails db:setup &&\
    rails db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]  
