FROM node:8.11

WORKDIR /opt/project

RUN npm i -g yarn && npm cache clean --force;

# cache deps
COPY .cache/package.json package.json
COPY .cache/yarn.lock yarn.lock
RUN yarn && yarn cache clean;

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn && yarn cache clean;

CMD sleep 300
