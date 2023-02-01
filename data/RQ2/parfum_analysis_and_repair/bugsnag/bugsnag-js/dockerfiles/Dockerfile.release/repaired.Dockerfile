FROM node:14-alpine
RUN apk add --no-cache --update git bash python3 make gcc g++ openssh-client curl

RUN addgroup -S admins
RUN adduser -S releaser -G admins

WORKDIR /app

RUN chown -R releaser:admins /app
USER releaser

COPY ./bin/release.sh ./

CMD ./release.sh
