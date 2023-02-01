FROM node:16 as build

WORKDIR /app
COPY . .
RUN yarn --immutable && yarn cache clean;
RUN yarn atlas:build && yarn cache clean;

FROM nginx:stable as nginx

WORKDIR /usr/app
COPY --from=build /app/packages/atlas/dist /usr/share/nginx/html
COPY ./ci/nginx /etc/nginx/templates
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
