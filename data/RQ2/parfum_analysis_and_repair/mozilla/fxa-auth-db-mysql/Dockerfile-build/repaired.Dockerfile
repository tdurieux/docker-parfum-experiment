FROM node:10-alpine

RUN npm install -g npm@6 && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

RUN apk add --no-cache make git gcc g++ python

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
WORKDIR /app

# S3 bucket in Cloud Services prod IAM
ADD https://s3.amazonaws.com/dumb-init-dist/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

USER app

COPY npm-shrinkwrap.json npm-shrinkwrap.json
COPY package.json package.json

RUN npm install --production && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

COPY . /app
