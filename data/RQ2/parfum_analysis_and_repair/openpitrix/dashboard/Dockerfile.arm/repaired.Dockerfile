FROM node:12-alpine as builder
MAINTAINER sunnyw <sunnywang@yunify.com>

ENV SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass
ENV PATH=$PATH:/home/node_modules/.bin

WORKDIR /home/app

RUN mkdir -p /home/app

RUN npm config set registry https://registry.npm.taobao.org

COPY package.json yarn.lock /tmp/

# generate dev node modules and prod node modules
RUN cd /tmp && mkdir -p node_modules \
    && yarn install --pure-lockfile --prefer-offline \
    && mv node_modules dev_node_modules \
    && NODE_ENV=production yarn install --pure-lockfile --prod --prefer-offline \
    && mv node_modules prod_node_modules \
    && mv dev_node_modules node_modules && yarn cache clean;

COPY . /home/app

RUN cd /home/app && \
    ln -fs /tmp/node_modules && \
    yarn prod:build


FROM yobasystems/alpine-nodejs:min-aarch64

ENV NODE_ENV=production

WORKDIR /home/app

RUN mkdir -p /home/app

COPY --from=builder /home/app /home/app
COPY --from=builder /tmp/prod_node_modules /home/app/node_modules

EXPOSE 8000

CMD ["npm", "run", "prod:serve"]
