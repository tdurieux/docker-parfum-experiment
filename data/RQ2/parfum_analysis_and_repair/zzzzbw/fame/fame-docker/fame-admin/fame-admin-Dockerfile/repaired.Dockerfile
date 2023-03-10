# build stage
FROM node:10.22.0-alpine as build-stage

RUN npm config set registry https://registry.npm.taobao.org

WORKDIR /app
COPY ./fame-admin .

RUN npm install && npm cache clean --force;
RUN npm run build

# production stage
FROM nginx:1.15.3-alpine as production-stage

MAINTAINER zzzzbw "zzzzbw@gmail.com"

COPY ./fame-docker/fame-admin/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]