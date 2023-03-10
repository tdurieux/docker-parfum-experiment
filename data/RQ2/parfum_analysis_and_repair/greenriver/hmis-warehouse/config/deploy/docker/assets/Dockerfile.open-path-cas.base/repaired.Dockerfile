# Move less frequently changing things higher in this file.

###############################################################
## Multi-stage build for the self-signed certificate we need ##
###############################################################

FROM alpine:latest AS builder

RUN apk add --no-cache \
  openssl

WORKDIR /

RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
  -subj "/C=US/ST=Vermont/L=Brattleboro/O=greenriver/CN=www.example.com" \
  -keyout key.pem -out cert.pem


##################
## Actual Build ##
##################

FROM open-path-cas:latest--pre-cache

# push up to pre-cache
RUN mkdir -p locale var
ENV RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8

ARG GITHASH
ARG BUILDER

LABEL "app"=open-path-cas
LABEL "ruby-version"=2.6.5

# Get self-signed cert
COPY --from=builder /key.pem /cert.pem /app/config/

# allow tls connection to database with verification
COPY config/deploy/docker/assets/rds-combined-ca-bundle.pem /etc/ssl/certs/rds-combined-ca-bundle.pem

COPY Gemfile Gemfile.lock Rakefile config.ru ./
COPY bin ./bin
COPY public ./public
COPY config/deploy/docker/assets/download_secrets.rb ./bin
COPY config/deploy/docker/lib ./bin
COPY config/deploy/docker/assets/deploy_tasks.open-path-cas.sh ./bin/deploy_tasks.sh

RUN bundle install --without=development

# some weird build issue on github: https://github.com/moby/moby/issues/37965
# which is what the RUN true is for

COPY lib ./lib
COPY config ./config
COPY spec ./spec
COPY db ./db
COPY --chown=app:app app ./app
COPY vendor ./vendor
COPY locale ./locale

RUN mkdir -p app/assets/stylesheets/theme/styles && \
  touch app/assets/stylesheets/theme/styles/_variables.scss && \
  cp config/deploy/docker/assets/database.open-path-cas.yml config/database.yml && \
  rm -rf tmp/* && \
  rm .env && \
  mkdir tmp/pids

COPY config/deploy/docker/assets/REVISION ./

COPY config/deploy/docker/assets/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

USER app

# Expose the GITHASH to entrypoint.sh for downloading precompiled assets.