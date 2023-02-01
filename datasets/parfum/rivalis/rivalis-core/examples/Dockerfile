FROM node:16.14.0-alpine3.15

RUN apk add --update --no-cache python3 make g++
RUN ln -sf python3 /usr/bin/python

WORKDIR /opt/workspace

COPY . .

RUN npm install

RUN npm run build:server

ENV INSTANCE_NAME null
ENV INSTANCE_PORT 2334
ENV INSTANCE_HOSTNAME 0.0.0.0
ENV INSTANCE_REGISTRY_TOKEN null
ENV INSTANCE_REGISTRY_URL null
ENV INSTANCE_RS256_PUBLIC_KEY null
ENV INSTANCE_LOG_LEVEL 3

CMD ["node", "./build/index.js"]