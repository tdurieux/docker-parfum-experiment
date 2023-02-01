FROM ruby:2.7.6
LABEL maintainer="nabeta@fastmail.fm"

ARG UID=1000
ARG GID=1000
ARG http_proxy
ARG https_proxy

RUN apt-get update -qq && apt-get install --no-install-recommends -y npm postgresql-client libpq-dev imagemagick mupdf-tools ffmpeg && npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN groupadd --gid ${GID} enju && useradd -m --uid ${UID} --gid ${GID} enju
RUN mkdir /enju && chown -R enju:enju /enju

USER enju
WORKDIR /enju
COPY Gemfile /enju/
COPY Gemfile.lock /enju/
RUN bundle install
COPY . /enju/
