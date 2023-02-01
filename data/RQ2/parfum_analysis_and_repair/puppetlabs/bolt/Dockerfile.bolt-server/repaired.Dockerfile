# Install gems
FROM alpine:3.14 as build

RUN \
  apk --no-cache add build-base ruby-dev ruby-bundler ruby-json ruby-bigdecimal git openssl-dev linux-headers \
  && echo 'gem: --no-document' > /etc/gemrc \
  && mkdir /bolt-server

# Gemfile requires gemspec which requires bolt/version which requires bolt
ADD . /bolt-server
WORKDIR /bolt-server
RUN bundle config --local silence_root_warning 1 \
  && bundle config --local path 'vendor/bundle' \
  && bundle install --no-cache --jobs=$(nproc)

# Final image