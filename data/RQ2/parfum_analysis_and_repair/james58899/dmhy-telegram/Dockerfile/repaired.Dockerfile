FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /app

RUN apk add --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime
ADD . .
RUN yarn

ENTRYPOINT [ "node", "." ]