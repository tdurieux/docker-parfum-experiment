FROM ruby:slim
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  git \
  build-essential \
  libpq-dev \
  curl && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler
RUN mkdir /stretchy
WORKDIR /stretchy
ADD . /stretchy
RUN bundle install

