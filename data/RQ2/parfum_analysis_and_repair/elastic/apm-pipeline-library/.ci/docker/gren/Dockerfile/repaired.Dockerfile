FROM node:14.5.0-stretch-slim

RUN apt-get update -qq -y \
  && apt-get install -qq -y --no-install-recommends git \
  && rm -rf /var/lib/apt/lists/*

RUN npm install github-release-notes@0.17.3 -g && npm cache clean --force;
WORKDIR /app
ENTRYPOINT [ "/usr/local/bin/gren" ]
