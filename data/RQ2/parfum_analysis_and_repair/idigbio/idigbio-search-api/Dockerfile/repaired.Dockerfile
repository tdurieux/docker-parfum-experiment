# This doesn't work because `node:6` is based on Debian 8 which
# doesn't have a recent enough version of libstdc++5-dev, we need
# node6 for other features though and in order for mapnik to work on
# node6 we need the recent C++.
#FROM node:6

FROM ubuntu:xenial
RUN apt-get update; apt-get install --no-install-recommends -y wget build-essential python && rm -rf /var/lib/apt/lists/*;
RUN wget -O /tmp/nodesource_setup.sh https://deb.nodesource.com/setup_6.x; bash /tmp/nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;
RUN mkdir -p /var/www; chown www-data:www-data /var/www
USER www-data
WORKDIR /var/www
ADD package.json /var/www/package.json
RUN npm install && npm cache clean --force;
RUN yarn install; yarn cache clean && yarn cache clean;
ADD . /var/www
RUN yarn build && yarn cache clean;

EXPOSE 19196

CMD ["npm", "start"]
