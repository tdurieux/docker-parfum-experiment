FROM node:14-slim

RUN apt-get update && apt-get -y --no-install-recommends install mongodb mongodb-server mongodb-clients && rm -rf /var/lib/apt/lists/*;

ADD . /mapcontrib

WORKDIR /mapcontrib
RUN npm install && npm cache clean --force;
RUN npm run build

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
VOLUME ["/mapcontrib/config", "/mapcontrib/public/files", "/var/lib/mongo"]

CMD ["/entrypoint.sh"]
