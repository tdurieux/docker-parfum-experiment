FROM node:12-stretch-slim as build

WORKDIR /tmp

RUN apt-get update && apt-get install -y \
  python \
  g++ \
  make \
  git \
  --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY ./ndid-logger/package*.json /tmp/api/ndid-logger/
COPY ./mq-server/package*.json /tmp/api/mq-server/

WORKDIR /tmp/api/ndid-logger
RUN npm install && npm prune --production && npm cache clean --force;

WORKDIR /tmp/api/mq-server
RUN npm install && npm cache clean --force;

COPY ./ndid-error /tmp/api/ndid-error
COPY ./ndid-logger /tmp/api/ndid-logger
COPY ./mq-server /tmp/api/mq-server

RUN npm run build && npm prune --production


FROM node:12-stretch-slim
LABEL maintainer="NDID IT Team <it@ndid.co.th>"

# Set umask to 027
RUN umask 027 && echo "umask 0027" >> /etc/profile

RUN apt-get update && apt-get install -y \
  openssl \
  --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY --from=build /tmp/api/ndid-error /api/ndid-error
COPY --from=build /tmp/api/ndid-logger /api/ndid-logger
COPY --from=build /tmp/api/mq-server /api/mq-server

COPY ./protos /api/protos
COPY COPYING /api/
COPY VERSION /api/

WORKDIR /api/mq-server

ENTRYPOINT [ "node", "/api/mq-server/build/server.js" ]
