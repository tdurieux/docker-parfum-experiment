# ============================================
# Build the files
# ============================================
FROM node:12 AS builder

RUN mkdir -p /app/_dist
WORKDIR /app

ENV NODE_PATH=src

COPY yarn.lock /app/yarn.lock
COPY package.json /app/package.json
RUN yarn

COPY static.config.js /app/static.config.js
COPY .babelrc /app/.babelrc
COPY .storybook /app/.storybook

ARG GOOGLE_ANALYTICS
ENV GOOGLE_ANALYTICS=${GOOGLE_ANALYTICS:-UA-110716917-2}

ARG FEEDBACK_API
ENV FEEDBACK_API=${FEEDBACK_API:-https://coa-test-form-api.herokuapp.com/process/}

ARG CMS_API
ENV CMS_API=${CMS_API:-https://joplin.herokuapp.com/api/graphql}

ARG CMS_MEDIA
ENV CMS_MEDIA=${CMS_MEDIA:-https://joplin-austin-gov.s3.amazonaws.com/media}

ARG CMS_DOCS
ENV CMS_DOCS=${CMS_DOCS:-https://joplin3-austin-gov-static.s3.amazonaws.com/production/media/documents}

COPY public /app/public
COPY src /app/src
RUN yarn build
RUN yarn build-storybook

# ============================================
# Serve the built files
# ============================================