# Node image to use
FROM node:16-alpine

# Directory where we run all the commands
WORKDIR /usr/local/apps/gateway-app

# Copy the package.json file to out image's filesystem
COPY ./gateway/package.json ./

# Copy supergraph
COPY ./supergraph.graphql ./

# Set working directory to /dev
WORKDIR /usr/local/apps/gateway-app/dev

# Copy all project files including node_modules because my internet can't handle
# installing them on every build