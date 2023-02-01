FROM arm32v6/node:lts-alpine
RUN apk add --update --no-cache openssh
WORKDIR /usr/local/teslacam
COPY package.json .
COPY yarn.lock .
RUN yarn --production
COPY . .
VOLUME ["/root/.ssh"]
VOLUME ["/home/pi/teslacam/video"]
ENTRYPOINT ["node", "./src/dashcam-monitor"]