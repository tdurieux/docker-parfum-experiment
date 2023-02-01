ARG NODE_JS_VERSION=16
FROM node:${NODE_JS_VERSION}

# Create app directory
WORKDIR /usr/src/app

RUN apt-get clean -y
RUN apt-get update -y && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
