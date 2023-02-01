# from base image node
FROM node:12.11-slim

ENV workdirectory /usr/node

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

ADD index.js .

# command executable and version
ENTRYPOINT ["node"]