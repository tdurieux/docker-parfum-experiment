FROM node:14.19-alpine3.15 as build

# adding python for node-gyp
RUN apk add --no-cache g++ make python3

# adding to solve vuln
RUN apk add --no-cache --update --upgrade busybox
RUN apk add --no-cache --update --upgrade libretls
RUN apk add --no-cache --update --upgrade openssl

COPY . /app
WORKDIR /app

# Installing packages
RUN yarn install --frozen-lockfile && yarn cache clean;

CMD ["yarn", "start"]
