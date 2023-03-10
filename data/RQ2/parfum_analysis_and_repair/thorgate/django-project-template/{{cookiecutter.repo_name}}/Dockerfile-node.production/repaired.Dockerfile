# Based on Node {{ cookiecutter.node_version }} Alpine image
FROM node:{{ cookiecutter.node_version }}-alpine

# Set the default directory where CMD will execute
WORKDIR /app

# Create a directory for the logs
RUN mkdir -p /var/log/{{cookiecutter.repo_name}}

# Mark assets directory as volume
VOLUME /files/assets

# Copy package files
COPY ./app/package.json ./
COPY ./app/yarn.lock ./

# Install node build dependencies
RUN apk add --no-cache --virtual .build-deps alpine-sdk python3 bash

# Install node dependencies
RUN yarn install --frozen-lockfile && yarn cache clean;

# Remove node build dependencies
RUN apk del .build-deps

# Copy code
COPY ./app /app

# Define the PORT environment var so that razzle can pick it up in the following `yarn build` command.
# It may be overridden in the .env file when the container is run.
ENV PORT 80

# Build node app
RUN yarn build

# Set the default command to execute when creating a new container
CMD yarn start
