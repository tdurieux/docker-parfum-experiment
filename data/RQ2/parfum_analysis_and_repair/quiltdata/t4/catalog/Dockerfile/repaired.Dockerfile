FROM ubuntu:16.04
MAINTAINER Quilt Data, Inc. contact@quiltdata.io

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    gettext \
    libssl-dev \
    build-essential \
    libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000

RUN mkdir /opt/app
WORKDIR /opt/app

# Install dependencies
COPY package.json .
COPY internals internals
RUN npm install && npm cache clean --force;

# Install the app
COPY . .
COPY config.json.example static/config.json
COPY federation.json.example static/federation.json
RUN npm run build:dll
CMD npm start
