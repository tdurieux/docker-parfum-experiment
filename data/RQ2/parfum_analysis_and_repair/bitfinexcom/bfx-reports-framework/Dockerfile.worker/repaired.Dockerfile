FROM node:14.16.0-alpine

ARG GRC_VER="0.7.1"

WORKDIR /home/node/grenache-cli

RUN apk update && apk add --no-cache --virtual \
  .gyp \
  python3 \
  make \
  jq \
  help2man \
  gcc \
  musl-dev \
  autoconf \
  automake \
  libtool \
  pkgconfig \
  file \
  patch \
  bison \
  clang \
  flex \
  curl \
  perl \
  perl-dev \
  wget \
  g++ \
  git \
  openssh \
  bash

RUN wget -c https://github.com/bitfinexcom/grenache-cli/releases/download/${GRC_VER}/grenache-cli-${GRC_VER}.tar.xz \
  && tar -xf grenache-cli-${GRC_VER}.tar.xz \
  && cd grenache-cli-${GRC_VER} \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && grenache-keygen && rm grenache-cli-${GRC_VER}.tar.xz

WORKDIR /home/node/bfx-reports-framework

COPY package*.json .npmrc ./
RUN npm i --production --no-audit && npm cache clean --force;

COPY ./config ./config
RUN cp config/schedule.json.example config/schedule.json \
  && cp config/common.json.example config/common.json \
  && cp config/service.report.json.example config/service.report.json \
  && cp config/facs/grc.config.json.example config/facs/grc.config.json \
  && cp config/facs/grc-slack.config.json.example config/facs/grc-slack.config.json

COPY . .
COPY ./scripts/worker-entrypoint.sh /usr/local/bin/

HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD grenache-lookup -g ${GRAPE_HOST} -p ${GRAPE_APH} "rest:report:api" \
    || kill 1

ENTRYPOINT ["worker-entrypoint.sh"]
CMD ["worker.js"]
