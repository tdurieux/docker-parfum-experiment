FROM node:12.11.1-alpine

WORKDIR /web

# Install tools
RUN apk add --no-cache git
RUN apk add --no-cache bash
RUN apk add --no-cache curl

# Install dependencies

COPY frontend/package.json frontend/yarn.lock frontend/

WORKDIR /web/frontend

RUN yarn && yarn cache clean;

WORKDIR /web

COPY . .

ARG CODECOV_TOKEN

ENV CODECOV_TOKEN=${CODECOV_TOKEN}

ARG RECAPTCHA_SITE_KEY

ENV REACT_APP_RECAPTCHA_SITE_KEY=${RECAPTCHA_SITE_KEY}

ARG CHROME_EXTENSION_ID

ENV CHROME_EXTENSION_ID=${CHROME_EXTENSION_ID}

CMD ["./scripts/frontend-report-coverage"]