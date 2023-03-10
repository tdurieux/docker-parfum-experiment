# docker build -t editor:latest -f Dockerfile-editor .

FROM ruby:2.5-slim-stretch

# install phusion passenger (step #1 from https://www.phusionpassenger.com/library/install/nginx/install/oss/bionic/)
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends dirmngr gnupg \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y --no-install-recommends apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list' && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/man/man1 \
  && mkdir -p /usr/share/man/man7 \
  && apt-get update -qq && apt-get install -y --no-install-recommends \
    logrotate imagemagick postgresql-client nodejs phantomjs build-essential \
    libpqxx-dev libmagickwand-dev libxml2-dev libxslt1-dev libsasl2-dev libffi-dev \
    libgd-dev libarchive-dev libbz2-dev nginx-full libnginx-mod-http-passenger \
    gettext-base \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/editor-website
COPY editor-website/Gemfile /srv/editor-website/Gemfile
COPY editor-website/Gemfile.lock /srv/editor-website/Gemfile.lock

ENV RAILS_ROOT /srv/editor-website

WORKDIR $RAILS_ROOT
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem install bundler -v=1.17.3 \
  && gem install bundle \
  && gem update --system \
  && bundle update --bundler \
  && bundle install \
  && rm -rf /srv/editor-website && rm -rf /root/.gem;

WORKDIR /

ARG BUILD_ENV=production

ENV SECRET_KEY_BASE dummytokenforbuild

COPY ./editor-website/ /srv/editor-website/
COPY ./container /C

WORKDIR $RAILS_ROOT

RUN rm -f config/credentials.yml.enc \
  && EDITOR=touch bundle exec rails credentials:edit \
  && /bin/sh /C/tools/subst /C/secrets/secrets.env \
     /C/config/editor/database.yml.in /srv/editor-website/config/database.yml \
     /C/config/editor/settings.local.yml.in /srv/editor-website/config/settings.local.yml \
  && bundle exec rake i18n:js:export assets:precompile \
  && rm -fr /C

ENTRYPOINT ["nginx", "-g", "daemon off;"]
