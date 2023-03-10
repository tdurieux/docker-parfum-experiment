FROM arm32v6/node:lts-alpine
RUN apk add --update --no-cache openssh
WORKDIR /usr/local/teslacam
COPY package.json .
COPY yarn.lock .
RUN yarn --production && yarn cache clean;
COPY . .
VOLUME ["/video"]
ENV BACKUP_DIR /video
ENV WAIT_INTERVAL 600000
RUN unset USE_SSH
ENTRYPOINT ["node", "./src/clean-recent-clips"]