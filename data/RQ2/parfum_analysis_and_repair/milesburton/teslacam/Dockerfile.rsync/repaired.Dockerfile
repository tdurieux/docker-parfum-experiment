FROM arm32v6/node:lts-alpine
RUN apk add --update --no-cache openssh rsync
WORKDIR /usr/local/teslacam
COPY package.json .
COPY yarn.lock .
RUN yarn --production && yarn cache clean;
COPY . .
ENV BACKUP_DIR /video
VOLUME ["/root/.ssh", "/video"]
ENTRYPOINT ["node", "./src/rsync-upload"]