# Use a node 14 base image
FROM node:14-alpine

# Create the app directory
WORKDIR /usr/src/app

# Install git
RUN apk add --no-cache git

# Copy context files
COPY ./package.json ./
COPY packages/generic/core/package.json ./packages/generic/core/
COPY packages/generic/backend/package.json ./packages/generic/backend/
COPY packages/courDeCassation/package.json ./packages/courDeCassation/
COPY yarn.lock ./

# Install dependencies
RUN yarn install --pure-lockfile && yarn cache clean;
COPY . .

RUN yarn buildDev
RUN chmod +x ./scripts/*

# Start the app
CMD ["yarn", "startLocalDev"]
