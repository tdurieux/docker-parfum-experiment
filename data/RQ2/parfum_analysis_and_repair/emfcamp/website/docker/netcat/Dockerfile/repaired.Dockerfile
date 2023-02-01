FROM node:12-alpine

RUN apk add --no-cache netcat-openbsd

ENTRYPOINT ["nc"]
