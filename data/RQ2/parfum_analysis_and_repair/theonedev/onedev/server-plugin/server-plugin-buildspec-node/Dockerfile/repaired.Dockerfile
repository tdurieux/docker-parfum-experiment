FROM node:10.16.1-alpine

RUN apk add --no-cache chromium
ENV CHROME_BIN /usr/bin/chromium-browser
ENV CHROMIUM_USER_FLAGS --no-sandbox
