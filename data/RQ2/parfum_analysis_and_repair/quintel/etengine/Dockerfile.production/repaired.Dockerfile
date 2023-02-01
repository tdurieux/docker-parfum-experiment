FROM ruby:3.1-slim

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    automake \
    autoconf \
    build-essential \
    default-libmysqlclient-dev \
    git \
    gnupg \
    graphviz \
    libreadline-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    nodejs \
    zlib1g \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler:1.17.3

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile* /app/
WORKDIR /app
RUN bundle config set --local deployment 'true'
RUN bundle install --jobs=4 --retry=3 --without="development test"

COPY . /app/

RUN RAILS_ENV=production bundle exec rails assets:precompile

CMD [".docker/entrypoint.sh"]
