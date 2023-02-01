FROM node:10-alpine

RUN apk add --no-cache --update
RUN apk add --no-cache unzip
RUN apk add --no-cache git

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
COPY package.json /tmp/package.json
RUN cd /tmp && npm install --production && npm cache clean --force;
RUN mkdir -p /sample-express-app && cp -a /tmp/node_modules /sample-express-app

# From here we load our application's code in, therefore the previous docker
# "layer" that has been cached, will be used if possible
WORKDIR /sample-express-app
COPY . /sample-express-app

EXPOSE  80

ENTRYPOINT [ "/bin/sh", "-c", "npm run start:env" ]
