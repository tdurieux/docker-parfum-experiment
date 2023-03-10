# Use a node 14 base image
FROM node:14-alpine

# Create the app directory
WORKDIR /usr/src/app

# Copy context files
COPY ./package.json ./
COPY packages/generic/backend/package.json ./packages/generic/backend/
COPY packages/generic/client/package.json ./packages/generic/client/
COPY packages/generic/core/package.json ./packages/generic/core/
COPY packages/courDeCassation/package.json ./packages/courDeCassation/
COPY yarn.lock ./

# Install dependencies
RUN export HTTP_PROXY="http://rie-proxy.justice.gouv.fr:8080/" \
  && export HTTPS_PROXY="http://rie-proxy.justice.gouv.fr:8080/" \
  && yarn install --pure-lockfile \
  && unset HTTP_PROXY \
  && unset HTTPS_PROXY && yarn cache clean;

COPY . .

RUN yarn build
RUN chmod +x ./scripts/*

# Start the app
CMD ["yarn", "startProd"]
