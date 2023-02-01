ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim
  RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN set -ex \
  && gem update --system --silent --quiet \
  && apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libcurl4-openssl-dev \
  && apt-get clean && rm -rf /root/.gem; && rm -rf /var/lib/apt/lists/*;
WORKDIR /app/github-pages-health-check
COPY Gemfile .
COPY github-pages-health-check.gemspec .
COPY lib/github-pages-health-check/version.rb lib/github-pages-health-check/version.rb
RUN bundle install
COPY . .
ENTRYPOINT [ "/bin/bash" ]
