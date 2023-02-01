FROM node:lts-alpine

RUN apk add --no-cache dumb-init

WORKDIR /emailengine
COPY . .

RUN npm install --production

ENV EENGINE_APPDIR=/emailengine
ENV EENGINE_HOST=0.0.0.0

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD node ${EENGINE_APPDIR}/server.js