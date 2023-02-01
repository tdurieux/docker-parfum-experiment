FROM node:14-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    graphicsmagick \
    g++ \
    git \
    make && rm -rf /var/lib/apt/lists/*;

ADD . /server
WORKDIR /server

RUN rm -rf node_modules && \
    rm -f log/*.log && \
    mkdir -p ./public/files/attachments/thumbnails && \
    mkdir -p ./public/files/attachments/thumbnails2 && \
    yarn install && yarn cache clean;

ENV NODE_ENV production

CMD ["yarn","start"]