ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -f -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev nodejs yarn libvips-dev && rm -rf /var/lib/apt/lists/*;

ENV LANG C.UTF-8
ENV GEM_HOME /bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $BUNDLE_PATH
ENV BUNDLE_BIN $BUNDLE_PATH/bin
# Add bundle dir to path to be able to access commands outside of `bundle exec`
ENV PATH /app/bin:$BUNDLE_BIN:$PATH
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && rm -rf /root/.gem;

RUN mkdir -p /app
WORKDIR /app
