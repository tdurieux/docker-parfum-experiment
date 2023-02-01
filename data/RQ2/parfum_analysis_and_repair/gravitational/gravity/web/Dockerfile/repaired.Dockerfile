FROM node:12.18.3-stretch-slim

RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

# prepare to install only package.json dependencies
RUN mkdir -p /app
COPY package*.json /app/

# copy the rest of the app files
WORKDIR /app

RUN npm set audit false ; \
    npm install --silent && npm cache clean --force;

COPY . /app

# and build
RUN npm run build
