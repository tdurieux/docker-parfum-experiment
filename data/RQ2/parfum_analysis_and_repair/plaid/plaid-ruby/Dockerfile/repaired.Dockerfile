FROM ruby:2.4.0

# Create app directory
WORKDIR /usr/src/app

# Copy app to directory
COPY . /usr/src/app

ENV BUNDLER_VERSION 2.2.9
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && rm -rf /root/.gem;
RUN gem install bundler:2.2.9
RUN bundle install

CMD ["bundle", "exec", "rake", "test"]
