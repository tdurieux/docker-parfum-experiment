FROM node:12.13.0 as build-stage
WORKDIR /app

COPY ./package.json /app/package.json
COPY ./yarn.lock /app/yarn.lock

RUN yarn install && yarn cache clean;

COPY ./ ./
RUN yarn build && yarn cache clean;

FROM nginx
COPY --from=build-stage /app/build /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
