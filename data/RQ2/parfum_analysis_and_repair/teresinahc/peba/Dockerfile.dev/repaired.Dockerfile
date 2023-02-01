FROM ruby:2.2.1

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  locales \
  nodejs \
  unzip \
  libxml2-utils && rm -rf /var/lib/apt/lists/*;

RUN locale-gen pt_BR.UTF-8
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt
ENV LC_ALL pt_BR.UTF-8

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs=20

WORKDIR /app
