FROM ruby:2.7.6-bullseye
MAINTAINER BioSistemika <info@biosistemika.com>

ARG WKHTMLTOPDF_PACKAGE_URL=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb

# additional dependecies
# libreoffice for file preview generation
RUN apt-get update -qq && \
  apt-get install -y \
  libjemalloc2 \
  libssl-dev \
  nodejs \
  npm \
  groff-base \
  awscli \
  postgresql-client \
  netcat \
  default-jre-headless \
  poppler-utils \
  librsvg2-2 \
  libvips42 \
  sudo graphviz --no-install-recommends \
  libreoffice \
  fonts-droid-fallback \
  fonts-noto-mono \
  fonts-wqy-microhei \
  fonts-wqy-zenhei \
  libfile-mimeinfo-perl && \
  wget -q -O /tmp/wkhtmltox_amd64.deb $WKHTMLTOPDF_PACKAGE_URL && \
  apt-get install --no-install-recommends -y /tmp/wkhtmltox_amd64.deb && \
  rm /tmp/wkhtmltox_amd64.deb && \
  npm install -g yarn && \
  ln -s /usr/lib/x86_64-linux-gnu/libvips.so.42 /usr/lib/x86_64-linux-gnu/libvips.so && \
  rm -rf /var/lib/apt/lists/* && npm cache clean --force;

ENV RAILS_ENV production
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native

# install gems
COPY Gemfile* /usr/src/bundle/
COPY addons /usr/src/bundle/addons
WORKDIR /usr/src/bundle
RUN bundle install

# create app directory
ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . .
RUN rm -f $APP_HOME/config/application.yml $APP_HOME/production.env

RUN DATABASE_URL=postgresql://postgres@db/scinote_production \
  PAPERCLIP_HASH_SECRET=dummy \
  SECRET_KEY_BASE=dummy \
  DEFACE_ENABLED=true \
  bash -c "rake assets:precompile && rake deface:precompile"

CMD rails s -b 0.0.0.0
