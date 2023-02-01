FROM alpine:3.14

RUN apk add --no-cache git

RUN apk add --no-cache npm

RUN mkdir /app

WORKDIR /app

ENV BOT_VERSION=

RUN git clone https://github.com/Jystro/Minecraft-info-bot --depth 1 --branch ${BOT_VERSION} .

RUN npm ci

ENV DISCORD_TOKEN=

CMD ["node", "."]