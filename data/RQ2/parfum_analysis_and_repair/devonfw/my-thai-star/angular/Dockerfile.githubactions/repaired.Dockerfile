# 1. Build
FROM node:lts AS build
WORKDIR /app

COPY angular/package.json /app/package.json
COPY angular/package-lock.json /app/package-lock.json
RUN npm install && npm cache clean --force;
COPY angular/. /app
RUN npm run build -- --configuration=docker

# 2. Deploy
FROM nginx:latest
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apache2-utils curl \
  && rm -rf /var/lib/apt/lists/*
COPY angular/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/. /usr/share/nginx/html
COPY angular/docker-external-config.json /usr/share/nginx/html/docker-external-config.json
EXPOSE 80 443
