FROM alpine
RUN apk update; apk add --no-cache nodejs nodejs-npm
COPY * /twitter/
WORKDIR /twitter
CMD npm install;node main.js
