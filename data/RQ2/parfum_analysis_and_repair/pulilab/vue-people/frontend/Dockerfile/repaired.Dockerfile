FROM node:8.11.1-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app/
RUN echo "NODE_ENV=production" >> .env
# This is to allow yarn to install from github
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

# start command
CMD [ "yarn", "start" ]

