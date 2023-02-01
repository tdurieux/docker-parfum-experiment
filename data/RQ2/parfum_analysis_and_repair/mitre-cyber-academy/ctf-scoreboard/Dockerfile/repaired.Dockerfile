FROM ruby:2.7

WORKDIR /usr/src/app

ENV RAILS_ENV=production

COPY Gemfile Gemfile.lock ./

RUN apt update && apt install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system; rm -rf /root/.gem; bundle config set without 'development test'; bundle install

COPY . .

RUN SECRET_KEY_BASE=precompile bundle exec rake assets:precompile

EXPOSE 3000

CMD bash -c "bundle exec rails s -b 0.0.0.0"
