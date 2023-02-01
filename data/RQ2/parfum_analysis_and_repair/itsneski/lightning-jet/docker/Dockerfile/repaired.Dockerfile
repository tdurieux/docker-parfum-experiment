FROM node:lts-alpine

RUN apk update \
  && apk add --no-cache procps \
  && apk add --no-cache --virtual build-dependencies \
  make \
  gcc \
  g++ \
  python3

WORKDIR /app/

COPY . /app/

RUN npm install --python=$(which python3) && npm cache clean --force;

ENV PATH="/app:${PATH}"

ENTRYPOINT [ "/app/docker/start.sh" ]
