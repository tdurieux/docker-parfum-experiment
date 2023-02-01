FROM ruby:3.1.1-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    git \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler:2.3.8

WORKDIR /usr/src/app

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3002

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
