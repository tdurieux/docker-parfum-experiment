ARG RUBY_TEST_VERSION
FROM ruby:$RUBY_TEST_VERSION

WORKDIR /app/

COPY . .
ARG BUNDLE_VERSION
ARG GEMSETS
RUN gem install bundler -v ${BUNDLE_VERSION}
RUN bundle _${BUNDLE_VERSION}_ install --with "$GEMSETS" --binstubs

CMD ["bundle", "exec", "./bin/rake", "spec"]