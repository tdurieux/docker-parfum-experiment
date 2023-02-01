FROM alpine AS builder

WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache --update yarn
COPY package.json /app
RUN yarn --prod --registry https://registry.npm.taobao.org/

FROM keymetrics/pm2:latest-alpine

WORKDIR /app

# Bundle APP files
COPY dist /app/dist/
COPY client /app/client/
COPY package.json /app
COPY ecosystem.config.js /app

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
COPY --from=builder /app/node_modules /app/node_modules

CMD [ "pm2-runtime", "start", "ecosystem.config.js", "--env", "production" ]
