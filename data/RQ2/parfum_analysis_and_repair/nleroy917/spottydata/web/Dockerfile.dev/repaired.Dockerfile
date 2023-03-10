# use node + alpine image
FROM node:14.15.1-alpine

# open port
EXPOSE 3000

# make frontend dir
RUN mkdir /client

# install git
RUN apk update && apk upgrade && \
    apk add --no-cache git

# change to /frontend
WORKDIR /client

# copy over dependencies
COPY ./package*.json ./
COPY ./.env.local ./.env.local
COPY *.config.js ./
COPY tsconfig.json ./
COPY ./*.ts ./

# install dependencies
RUN yarn install && yarn cache clean;

# run
CMD ["yarn", "dev"]