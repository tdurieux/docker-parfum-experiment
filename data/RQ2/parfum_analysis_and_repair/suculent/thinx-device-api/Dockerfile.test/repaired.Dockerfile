FROM thinxcloud/base:alpine

LABEL maintainer="Matej Sychra <suculent@me.com>"
LABEL name="THiNX API" version="1.7.1915"

ARG DEBIAN_FRONTEND=noninteractive

# For test-env node-18
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
ENV NODE_EXTRA_CA_CERTS=/mnt/data/ssl/testRoot.crt

ARG THINX_HOSTNAME
ENV THINX_HOSTNAME=${THINX_HOSTNAME}

ARG THINX_OWNER_EMAIL
ENV THINX_OWNER_EMAIL=${THINX_OWNER_EMAIL}

ARG COUCHDB_USER
ENV COUCHDB_USER=${COUCHDB_USER}
ARG COUCHDB_PASS
ENV COUCHDB_PASS=${COUCHDB_PASS}
ARG REDIS_PASSWORD
ENV REDIS_PASSWORD=${REDIS_PASSWORD}

ARG CODACY_PROJECT_TOKEN
ENV CODACY_PROJECT_TOKEN=${CODACY_PROJECT_TOKEN}
ARG SONAR_TOKEN
ENV SONAR_TOKEN=${SONAR_TOKEN}
ARG ROLLBAR_ACCESS_TOKEN
ENV ROLLBAR_ACCESS_TOKEN=${ROLLBAR_ACCESS_TOKEN}
ARG ROLLBAR_ENVIRONMENT
ARG ROLLBAR_ENVIRONMENT=${ROLLBAR_ENVIRONMENT}
ARG AQUA_SEC_TOKEN
ENV AQUA_SEC_TOKEN=${AQUA_SEC_TOKEN}
ARG SNYK_TOKEN
ENV SNYK_TOKEN=${SNYK_TOKEN}
ARG SQREEN_TOKEN
ENV SQREEN_TOKEN=${SQREEN_TOKEN}

ARG GITHUB_ACCESS_TOKEN
ENV GITHUB_ACCESS_TOKEN={GITHUB_ACCESS_TOKEN}

ARG ENVIRONMENT
ENV ENVIRONMENT=${ENVIRONMENT}

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG SQREEN_APP_NAME
ENV SQREEN_APP_NAME=${SQREEN_APP_NAME}

ARG REVISION
ENV REVISION=${REVISION}

ARG GOOGLE_OAUTH_ID
ENV GOOGLE_OAUTH_ID=${GOOGLE_OAUTH_ID}
ARG GOOGLE_OAUTH_SECRET
ENV GOOGLE_OAUTH_SECRET=${GOOGLE_OAUTH_SECRET}

ARG GITHUB_CLIENT_ID
ENV GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID}
ARG GITHUB_CLIENT_SECRET
ENV GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET}

ARG SLACK_BOT_TOKEN
ENV SLACK_BOT_TOKEN=${SLACK_BOT_TOKEN}

ARG GITHUB_SECRET
ENV GITHUB_SECRET=${GITHUB_SECRET}

ARG ENTERPRISE
ENV ENTERPRISE=${ENTERPRISE}

ARG WORKER_SECRET
ENV WORKER_SECRET=${WORKER_SECRET}

ARG CIRCLE_NODE_TOTAL
ENV CIRCLE_NODE_TOTAL=${CIRCLE_NODE_TOTAL}

ARG CIRCLE_NODE_INDEX
ENV CIRCLE_NODE_INDEX=${CIRCLE_NODE_INDEX}

# Create app directory
WORKDIR /opt/thinx/thinx-device-api

# Install test dependencies
RUN apk add --no-cache openjdk8-jre p7zip

# Install app dependencies
COPY package.json ./

RUN npm install -g npm@8.6.0 \
    && npm install . && npm cache clean --force;

VOLUME /var/lib/docker

# THiNX Web & Device API (HTTP)
EXPOSE 7442

# THiNX Device API (HTTPS)
EXPOSE 7443

#??GitLab Webbook
EXPOSE 9002

# Copy app source code
COPY . .

RUN mkdir -p ./.nyc_output

# only for test mocking (may not work, will need structure with mock data in repo)
COPY ./spec/mnt /mnt

# download test reporter as a static binary
RUN curl -f -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
RUN chmod +x ./cc-test-reporter

# Test modules
RUN npm install -g nyc mocha jasmine mocha-lcov-reporter coveralls && npm cache clean --force;

# TODO: Implement Snyk Container Scanning here in addition to DockerHub manual scans...

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
