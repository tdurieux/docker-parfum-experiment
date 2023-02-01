FROM node:5.12

MAINTAINER Sean Canton <sean.canton@admobilize.com>

RUN apt-get update && apt-get install --no-install-recommends -yq libzmq3-dev \
  && apt-get clean && rm -rf /var/tmp/* && rm -rf /var/lib/apt/lists/*;

COPY . /matrix
RUN chmod +x /matrix/docker-entrypoint.sh

WORKDIR matrix/

RUN rm -r node_modules
RUN npm install && npm cache clean --force;

EXPOSE 80
ENTRYPOINT ["/matrix/docker-entrypoint.sh"]
CMD ["node"]
