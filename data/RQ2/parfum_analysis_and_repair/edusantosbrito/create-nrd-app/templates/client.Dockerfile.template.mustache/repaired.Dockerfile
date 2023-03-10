FROM node:14-slim as build
WORKDIR /usr/src/app
COPY . .
RUN yarn && yarn cache clean;
RUN yarn run build --production && yarn cache clean;
FROM nginx:1.19-alpine
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx
COPY --from=build /usr/src/app/build /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]