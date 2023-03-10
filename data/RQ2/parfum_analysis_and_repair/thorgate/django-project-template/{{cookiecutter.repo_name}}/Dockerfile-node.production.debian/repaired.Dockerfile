FROM node:{{ cookiecutter.node_version }}-buster-slim

# Install system requirements
# Use non-interactive frontend for debconf
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set the default directory where CMD will execute
WORKDIR /app

# Create a directory for the logs
RUN mkdir -p /var/log/{{cookiecutter.repo_name}}

# Mark assets directory as volume
VOLUME /files/assets

# Copy package files
COPY ./app/package.json ./
COPY ./app/yarn.lock ./

# Install system requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends git python && \
    rm -rf /var/lib/apt/lists/*

# Install node dependencies
RUN yarn install --frozen-lockfile && yarn cache clean;

# Copy code
COPY ./app /app

# Define the PORT environment var so that razzle can pick it up in the following `yarn build` command.
# It may be overridden in the .env file when the container is run.
ENV PORT 80

# Build node app
RUN yarn build

# Set the default command to execute when creating a new container
CMD yarn start
