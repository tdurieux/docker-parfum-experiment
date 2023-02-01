FROM node:14.16-alpine
WORKDIR /usr/temporal-web

# install git & openssh to fetch github packages
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

ENV NODE_ENV=development

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

# Bundle the client code
RUN npm run build