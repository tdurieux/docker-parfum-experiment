# TODO: Use alpine instead for smaller image.
#But first need to be able to run nodegit in alpine.
#FROM mhart/alpine-node:5.5.0

# Use node
FROM node:6-slim
# Build tools
RUN apt-get update && apt-get install --no-install-recommends -y git build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
# Install Empirical
COPY package.json /emp/package.json
WORKDIR /emp
RUN npm install && npm cache clean --force;
COPY . /emp
ENTRYPOINT ["node", "./bin/cli.js"]
