FROM node:10.16.1-alpine as dependencies
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

FROM dependencies as packaged
COPY ./ ./
RUN yarn build && yarn cache clean;

FROM nginx:1.17.2-alpine
COPY devops/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=packaged /app/build/ /usr/share/nginx/html