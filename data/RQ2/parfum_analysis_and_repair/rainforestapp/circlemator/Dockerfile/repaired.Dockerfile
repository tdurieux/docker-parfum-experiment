FROM ruby:2.7.4
RUN apt-get update -y && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# Set default locale for Ruby to avoid encoding errors
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /app
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler

COPY . .
RUN bundle install

# makes the circlemator binstub accessible outside this bundle
RUN rake install:local

ENTRYPOINT ["circlemator"]
