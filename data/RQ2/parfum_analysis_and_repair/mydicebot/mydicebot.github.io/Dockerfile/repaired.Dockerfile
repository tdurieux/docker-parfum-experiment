FROM keymetrics/pm2:latest-alpine

ARG PATHWORK
ARG PMFILE

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN mkdir -p /src
ADD $PATHWORK /src/package.json
ADD $PMFILE /src
WORKDIR /src
RUN npm install && npm cache clean --force;
RUN npm install express-generator -g && npm cache clean --force;
CMD pm2-runtime start ${PM} --env ${NODE_ENV}
EXPOSE 57432
