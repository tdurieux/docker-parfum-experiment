FROM node:lts-alpine

RUN apk add --no-cache ffmpeg

WORKDIR /app

COPY . .

RUN yarn install && yarn cache clean;
RUN yarn --cwd frontend install && yarn cache clean;

RUN yarn build

ENV YTDL_PORT=80 \
    YTDL_DOWNLOAD_DIR=/app/downloads \
    NODE_ENV=production

VOLUME /app/downloads

EXPOSE 80/tcp

CMD ["yarn", "start"]
