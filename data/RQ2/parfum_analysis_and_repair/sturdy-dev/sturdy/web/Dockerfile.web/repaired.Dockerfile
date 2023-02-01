FROM node:17.3-bullseye-slim

RUN apt-get update && apt-get install --no-install-recommends -y python3 build-essential git && rm -rf /var/lib/apt/lists/*;
WORKDIR /worker

ADD package.json .
ADD yarn.lock .

RUN yarn install && yarn cache clean;
