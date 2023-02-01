FROM node:14.18.0-alpine3.11 AS build-env

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
RUN npm install && npm cache clean --force;

COPY . ./

ARG ENVIRONMENT
RUN if [ "$ENVIRONMENT" = "dev" ] ; then npm run build:admin ; else npm run build:admin:prod ; fi

FROM nginx:1.13.9-alpine

COPY --from=build-env /app/dist/admin/ /usr/share/nginx/html

COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
