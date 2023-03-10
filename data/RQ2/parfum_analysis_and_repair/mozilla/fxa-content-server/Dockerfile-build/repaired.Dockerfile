FROM node:10-alpine

RUN npm install -g npm@6 && rm -rf ~app/.npm /tmp/* && npm cache clean --force;

RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
WORKDIR /app

# S3 bucket in Cloud Services prod IAM
ADD https://s3.amazonaws.com/dumb-init-dist/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

RUN apk add --no-cache git

COPY npm-shrinkwrap.json npm-shrinkwrap.json
COPY package.json package.json
COPY scripts/download_l10n.sh scripts/download_l10n.sh

RUN npm install --production --unsafe-perm && rm -rf ~/.cache ~/.npm /tmp/* && npm cache clean --force;

COPY . /app

RUN npm run build-production --unsafe-perm

USER app
