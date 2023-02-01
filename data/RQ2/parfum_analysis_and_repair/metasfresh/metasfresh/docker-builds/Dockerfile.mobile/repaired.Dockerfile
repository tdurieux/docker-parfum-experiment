FROM node:14 as build

RUN npm install -g webpack webpack-cli && npm cache clean --force;

WORKDIR /app
COPY misc/services/mobile-webui/mobile-webui-frontend/package.json .
# COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY misc/services/mobile-webui/mobile-webui-frontend/ .

RUN yarn lint && yarn cache clean;
# RUN yarn test --ci

ENV PUBLIC_URL=/
RUN yarn build && yarn cache clean;


FROM nginx:1.21.6 as runtime

COPY docker-builds/nginx/default.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html

COPY --from=build /app/build/ .