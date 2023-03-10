# 1. Build
FROM node:lts AS build
WORKDIR /app

COPY package.json /app/package.json
RUN npm install && npm cache clean --force;
COPY . /app
RUN npm run build -- --configuration=docker

# 2. Deploy
FROM bitnami/nginx:latest
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apache2-utils curl \
  && rm -rf /var/lib/apt/lists/*
COPY mts-nginx.conf /opt/bitnami/nginx/conf/server_blocks/mts-nginx.conf
COPY docker-external-config.json /usr/share/nginx/html/docker-external-config.json
COPY --from=build /app/dist/. /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=60s --timeout=30s --start-period=1s --retries=3 CMD curl --fail http://localhost:8080/health || exit 1
CMD ["nginx", "-g", "daemon off;"]
