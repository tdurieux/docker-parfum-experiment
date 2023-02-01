FROM vulhub/node:8.5.0

MAINTAINER phithon <root@leavesongs.com>

COPY package.json package-lock.json /usr/src/

RUN set -ex \
    && cd /usr/src \
    && npm install

WORKDIR /usr/src

CMD ["npm", "run", "start"]