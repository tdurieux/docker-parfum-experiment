FROM node:12.11.1-alpine

WORKDIR /web

# Install tools
RUN apk add --no-cache git
RUN apk add --no-cache bash

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

COPY . .

ARG RECAPTCHA_SITE_KEY

ENV CI=true
ENV REACT_APP_RECAPTCHA_SITE_KEY=${RECAPTCHA_SITE_KEY}

CMD ["./scripts/lint"]