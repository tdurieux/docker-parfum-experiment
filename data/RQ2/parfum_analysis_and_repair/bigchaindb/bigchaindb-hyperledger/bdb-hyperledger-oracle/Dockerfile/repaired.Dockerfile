FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  build-essential && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /rest_api

COPY  . .

RUN npm install && npm cache clean --force;