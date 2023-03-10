FROM node:16-alpine

# Why do we install these?
# RUN apk add --no-cache --virtual .gyp python make g++

WORKDIR /app

# We copy just the dependencies first to leverage Docker cache
COPY package.json /app
COPY package-lock.json /app

RUN npm install && npm cache clean --force;

COPY . /app

CMD ["npm", "start"]
