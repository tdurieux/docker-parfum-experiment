# NOTE: this image is only for local development it's not used by CI at this time

# Start from the latest Node.js image
FROM node:10-alpine

# Install git for Codecov
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash \
                       curl \
                       git \
                       jq \
                       openssh \
                       openssl

RUN mkdir -p /opt/splunk/splunk-cloud-sdk-js

# This value is used by forwarders tests to set a custom openssl path for cert generation
ENV CI=true

# Copy the content of your repository into the image
COPY . /opt/splunk/splunk-cloud-sdk-js

WORKDIR /opt/splunk/splunk-cloud-sdk-js

RUN npm -g uninstall yarn
RUN npm -g install yarn@1.9 && npm cache clean --force;

RUN yarn install --non-interactive && yarn build && yarn cache clean;

VOLUME /opt/splunk/splunk-cloud-sdk-js
