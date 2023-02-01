FROM node:17

RUN npm install -g webpack webpack-cli && npm cache clean --force;

WORKDIR /app
COPY misc/services/procurement-webui/procurement-webui-frontend/package.json .
# COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY misc/services/procurement-webui/procurement-webui-frontend/ .

RUN yarn lint
RUN yarn build
