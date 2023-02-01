FROM node:10.4.1-alpine

# progress=false stops npm from slowing to show a progress bar (because can't be seen in docker anyway)
RUN npm set progress=false && \
    npm config set depth 0

RUN npm install -g yarn && npm cache clean --force;

RUN mkdir /usr/src && mkdir /usr/src/app && mkdir /usr/src/data && rm -rf /usr/src

# Dockerize is used to set the startup order in the main compose that uses this image
RUN apk add --no-cache dockerize --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

# Copy this whole directory into /usr/src/app

COPY . .

CMD ["node", "start.js"]
