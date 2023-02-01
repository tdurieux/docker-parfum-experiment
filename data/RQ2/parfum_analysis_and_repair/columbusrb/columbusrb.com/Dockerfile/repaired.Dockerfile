FROM ruby:2.6.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile* ./
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;




RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update bundler && rm -rf /root/.gem;
RUN bundle install
COPY . /app/

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
