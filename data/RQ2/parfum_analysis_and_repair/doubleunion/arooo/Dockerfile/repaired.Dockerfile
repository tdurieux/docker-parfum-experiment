FROM ruby:2.7.1-slim

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl cmake git libpq-dev tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /app
WORKDIR /app

RUN gem install bundler -v 2.0.1

CMD ["bash"]
