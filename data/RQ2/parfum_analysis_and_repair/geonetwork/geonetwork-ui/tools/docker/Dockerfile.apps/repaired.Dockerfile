# This dockerfile should work for all traditional apps,
# i.e. it only sets up a nginx server with the app dist folder

FROM nginx:1.21.4-alpine

ARG APP_NAME="search"
ENV APP_NAME=${APP_NAME}
ENV GN4_API_URL ""
ENV PROXY_PATH ""
ENV CONFIG_DIRECTORY_OVERRIDE ""
ENV ASSETS_DIRECTORY_OVERRIDE ""

COPY dist/apps/${APP_NAME} /usr/share/nginx/html/${APP_NAME}
COPY tools/docker/docker-entrypoint.sh /

# copy default NGINX conf & put the app name in it