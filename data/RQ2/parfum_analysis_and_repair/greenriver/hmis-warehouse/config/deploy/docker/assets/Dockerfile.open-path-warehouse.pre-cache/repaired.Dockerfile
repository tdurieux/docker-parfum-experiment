#########################################################
## stage build for the self-signed certificate we need ##
#########################################################
FROM ruby:2.7.6-alpine3.15 AS cert

RUN apk add --no-cache \
  openssl

WORKDIR /

RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
    -subj "/C=US/ST=Vermont/L=Brattleboro/O=greenriver/CN=www.example.com" \
    -keyout key.pem -out cert.pem

########################
## Stage for the code ##
########################

FROM ruby:2.7.6-alpine3.15 AS code

RUN mkdir -p /app \
    /app/app/assets /app/tmp/pids /app/lib/assets /app/vendor/assets \
    /app/public /app/locale /app/var  \
    /app/shape_files/CoC /app/shape_files/zip_codes.census.2018 \
    /app/shape_files/block_groups /app/shape_files/states /app/shape_files/counties

WORKDIR /app

COPY Gemfile Gemfile.lock Rakefile config.ru package.json ./
COPY bin ./bin
COPY public ./public
COPY lib ./lib
COPY config ./config
COPY app ./app
COPY vendor ./vendor
COPY config/deploy/docker/assets/dotenv.temporary ./.env

COPY shape_files/sync.from.s3 ./shape_files
COPY shape_files/CoC/make.inserts ./shape_files/CoC
COPY shape_files/zip_codes.census.2018/make.inserts ./shape_files/zip_codes.census.2018
COPY shape_files/counties/make.inserts ./shape_files/counties
COPY shape_files/states/make.inserts ./shape_files/states
COPY shape_files/block_groups/make.inserts ./shape_files/block_groups

# Get self-signed cert
COPY --from=cert /key.pem /cert.pem /app/config/

##################
## Actual Build ##
##################

FROM ruby:2.7.6-alpine3.15

WORKDIR /app

# https://github.com/sass/sassc-ruby/issues/146#issuecomment-542288556
# core dumps during precompile on github when using the pre-cache image pulled
# from ECR
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    # Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    GROVER_NO_SANDBOX=true \
    CHROMIUM_PATH=/usr/bin/chromium-browser

# allow tls connection to database with verification
COPY config/deploy/docker/assets/rds-combined-ca-bundle.pem /etc/ssl/certs/rds-combined-ca-bundle.pem

RUN addgroup -g 1001 app \
  && adduser -u 1001 -G app -h /app -D app

COPY --from=code --chown=app:app /app /app/

# puppetteer line starts with chromium
# Installs latest Chromium package.
#
# lftp for tarrant county only at the moment