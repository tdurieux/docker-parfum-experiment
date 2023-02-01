FROM node:12

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install NPMs
COPY package.json* package-lock.json* /usr/src/app/
RUN npm i --production && npm cache clean --force;

COPY . /usr/src/app
RUN npm run build
