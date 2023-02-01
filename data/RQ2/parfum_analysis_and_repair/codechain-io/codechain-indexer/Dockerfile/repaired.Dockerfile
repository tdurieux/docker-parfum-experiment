# Use minideb instead of alpine since some modules use native binary not supported in alpine
FROM bitnami/node:10.9.0
WORKDIR /code

# Install git because we currently fetch codechain core from github
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

# Install yarn
RUN npm install yarn -g && npm cache clean --force;


# Copy package.json and lock file to install dependencies
COPY package.json yarn.lock /code/

# Install dependencies
RUN yarn

# Copy codechain indexer
COPY . /code

# Run server
CMD sh -c "./wait_to_start.sh && yarn run start"
