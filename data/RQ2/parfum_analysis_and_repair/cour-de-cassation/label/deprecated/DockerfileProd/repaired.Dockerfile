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
RUN yarn install --pure-lockfile && yarn cache clean;
COPY . .

RUN yarn build && yarn cache clean;
RUN chmod +x ./scripts/*

# Start the app
CMD ["yarn", "startProd"]
