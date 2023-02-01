# NAME:     homeland/homeland
FROM homeland/base:3.1.0-slim-buster

ENV RAILS_ENV "production"
ENV RUBYOPT "W0"

WORKDIR /home/app/homeland

VOLUME /home/app/homeland/plugins

RUN mkdir -p /home/app &&\
  rm -rf '/tmp/*' &&\
  rm -rf /etc/nginx/conf.d/default.conf

ADD Gemfile Gemfile.lock package.json yarn.lock /home/app/homeland/
# Do not enable bundle deployment, use globalize mode, Puma tmp_restart need it.