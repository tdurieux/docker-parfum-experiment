FROM node:9.1

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
    chromium \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN /usr/bin/chromium

COPY package.json /usr/src/app/package.json
WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;
COPY . /usr/src/app
