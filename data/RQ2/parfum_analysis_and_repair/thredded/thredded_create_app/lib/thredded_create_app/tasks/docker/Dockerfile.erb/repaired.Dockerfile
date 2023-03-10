# A Dockerfile for development.

FROM alpine:3.11

RUN apk add --no-cache \
    # Runtime deps
    ruby ruby-bundler ruby-bigdecimal ruby-io-console ruby-json ruby-webrick tzdata nodejs yarn bash \
    # Bundle install deps
    build-base ruby-dev libc-dev linux-headers gmp-dev openssl-dev libxml2-dev \
    libxslt-dev postgresql-dev

RUN gem install foreman

ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_PATH=/bundle
ENV DOCKER=1

ENV APP_HOME /<%= app_name %>
WORKDIR $APP_HOME
RUN mkdir -p $APP_HOME

# Copy Gemfile and run bundle install first to allow for caching
COPY Gemfile Gemfile.lock $APP_HOME/
RUN bundle --path=$BUNDLE_PATH -j $(nproc)

# Copy package.json and install dependencies (done here to allow for caching)