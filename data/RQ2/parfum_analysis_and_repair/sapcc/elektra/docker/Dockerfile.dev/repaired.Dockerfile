FROM keppel.eu-de-1.cloud.sap/ccloud-dockerhub-mirror/library/ruby:2.7-alpine3.15

LABEL source_repository="https://github.wdf.sap.corp/monsoon/workspaces/tree/master/environments/elektra"

ENV GIT_SSL_NO_VERIFY=true
ENV GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ENV TZ="Europe/Berlin"

RUN apk --no-cache add --update \
  git \
  curl \
  nodejs \
  build-base \
  npm \
  --virtual .builddeps \
  postgresql-dev \
  postgresql \
  postgresql-client \
  openssh \
  python2 \
  yarn \
  bash \
  unzip \
  sqlite-dev \
  jq \
  the_silver_searcher \
  vim \
  shared-mime-info \
  python3 \
  py3-pip\
  ca-certificates \
  gcc \
  libffi-dev \
  python3-dev \
  musl-dev \
  openssl-dev \
  g++ libxml2-dev \
  libxslt-dev \
  libjpeg-turbo-dev \
  zlib-dev \
  tshark

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir mitmproxy
ENV LANG=en_US.UTF-8

RUN pip3 install --no-cache-dir -U pip

# https://stackoverflow.com/questions/57284921/error-in-setting-up-mitmproxy-on-alpine-3-9
RUN pip3 install --no-cache-dir mitmproxy

RUN pip3 install --no-cache-dir pgcli

RUN mkdir /app
WORKDIR /app
VOLUME /app

################### POSTGRESQL
ENV PGDATA /app/tmp/postgresql/data

RUN gem install bundler && bundle config set --local path 'vendor/bundle'
RUN echo -e '#!/bin/bash\n\n\
  bundle install \n\
  yarn \n\
  mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA"\n\
  PGDATA_FILES=$(ls -A $PGDATA)\n\
  if [ -z "$PGDATA_FILES" ]; then\n\
  echo "INFO: setup database"\n\
  su - postgres -c "initdb $PGDATA" && chmod 700 $PGDATA\n\
  fi\n\
  mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql\n\
  su - postgres -c "pg_ctl -D $PGDATA -w start"\n\
  DISABLE_SPRING=1 bin/rails db:create && DISABLE_SPRING=1 bin/rails db:migrate\n\
  clear \n\
  /bin/bash -login' >> /usr/local/bin/start-db && chmod +x /usr/local/bin/start-db

RUN echo -e 'echo "Welcome to elektra dev container"\n\
  echo " - start rails:   start-rails"\n\
  echo " - start javascript:  start-js"\n\
  echo " - rebuild database:  rebuild-db"\n\
  echo " - rebuild npm:       rebuild-npm"\n\
  echo " - rebuild gems:      rebuild-gems"\n\
  echo " - postgres console:  pg-console"\n\
  echo " - proxy (port:8888): dev-proxy"\n\
  echo ""\n\
  echo " Note: elektra database are located in /app/tmp/postgresql/data/"\n\
  alias start-rails="cd /app && bin/rails s -b 0.0.0.0 -p $APP_PORT"\n\
  alias start-js="cd /app && yarn build --watch"\n\
  alias rebuild-npm="cd /app && rm -rf node_modules && yarn"\n\
  alias rebuild-gems="cd /app && rm -rf vendor/bundle && bundle install"\n\
  alias pg-console="su - postgres -c \"pgcli\""\n\
  alias dev-proxy="mitmproxy -p 8888"\n\
  alias rebuild-db="rm -rf /app/tmp/postgresql/data/* && echo Done! please exit elektra and start again..."' >> /root/.profile

ENTRYPOINT [ "/usr/local/bin/start-db" ] 
