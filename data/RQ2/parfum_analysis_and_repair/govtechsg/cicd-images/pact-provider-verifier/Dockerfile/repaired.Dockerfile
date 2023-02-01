ARG RUBY_MAJOR_VERSION="2"
FROM ruby:${RUBY_MAJOR_VERSION}-alpine
COPY ./version-info /usr/bin
RUN chmod +x /usr/bin/version-info
RUN gem install pact-provider-verifier