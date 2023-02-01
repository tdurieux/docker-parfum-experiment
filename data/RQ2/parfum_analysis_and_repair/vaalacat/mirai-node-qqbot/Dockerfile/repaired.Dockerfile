FROM node:16

RUN apt update && apt install --no-install-recommends python python3 sqlite3 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/qqbot
COPY ./src/package* /var/www/qqbot/

RUN npm --registry https://registry.npm.taobao.org install && npm cache clean --force;

COPY ./src/*.js /var/www/qqbot/

COPY ./src/plugins /var/www/qqbot/plugins

COPY ./src/data /var/www/qqbot/data

COPY ./src/config /var/www/qqbot/config

COPY ./src/*.sh /var/www/qqbot/

ENTRYPOINT [ "/var/www/qqbot/docker-entrypoint.sh" ]
