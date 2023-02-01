FROM node:14.16.0-alpine

ENV BIND_HOST "0.0.0.0"

WORKDIR /home/node/grenache-grape

RUN apk add --no-cache --virtual \
  .gyp \
  python3 \
  make \
  g++ \
  curl \
  git \
  openssh \
  bash

RUN git clone https://github.com/bitfinexcom/grenache-grape.git . \
  && npm i --production --no-audit && npm cache clean --force;

COPY ./scripts/grenache-grape-entrypoint.sh /usr/local/bin/

HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --retry-delay 10 --max-time 3 --retry 3 --retry-max-time 30 \
    -f -X POST -d '{}' \
    http://${BIND_HOST}:${GRAPE_APH} \
    || kill 1

ENTRYPOINT ["grenache-grape-entrypoint.sh"]
CMD ["bin/grape.js"]
