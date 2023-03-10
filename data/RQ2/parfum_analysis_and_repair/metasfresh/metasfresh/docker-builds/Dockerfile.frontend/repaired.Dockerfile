FROM node:17 as build

RUN npm install -g webpack webpack-cli && npm cache clean --force;

WORKDIR /app
COPY frontend/package.json .
# COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY frontend/ .

RUN yarn lint
# RUN yarn test --ci
RUN webpack --config webpack.docker.js


FROM nginx:1.21.6 as runtime

COPY docker-builds/nginx/default.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html

COPY --from=build /app/dist/ .