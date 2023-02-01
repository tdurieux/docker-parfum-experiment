FROM node:8.9 AS build
WORKDIR /app
COPY . /app
RUN yarn run build && yarn cache clean;

FROM bitnami/nginx
COPY --from=build /app/build /app
