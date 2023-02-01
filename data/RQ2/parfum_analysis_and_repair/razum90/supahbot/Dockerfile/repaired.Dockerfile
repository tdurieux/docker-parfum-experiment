FROM alpine:3.9.4

RUN apk add --no-cache --update alpine-sdk && \
  apk add --no-cache git && \
  apk add --no-cache --update nodejs nodejs-npm && \
  apk add --no-cache --update ffmpeg python

WORKDIR /usr/src/app
COPY . .
RUN npm install --silent && npm cache clean --force;
RUN npm test
CMD [ "npm", "start" ]