FROM ubuntu:latest

MAINTAINER Tarik "tariksahni@gmail.com"

ADD . .

COPY package.json .

COPY yarn.lock .

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash

RUN apt-get install --no-install-recommends -y git nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g yarn && npm cache clean --force;

RUN yarn install && yarn cache clean;

CMD yarn start