FROM mhart/alpine-node:11.12
MAINTAINER kai@blockchaintp.com
RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash git
WORKDIR /app/api
COPY ./package.json /app/api/package.json
COPY ./yarn.lock /app/api/yarn.lock
RUN yarn install && yarn cache clean;
COPY ./ /app/api
ENTRYPOINT ["yarn", "run", "serve"]
