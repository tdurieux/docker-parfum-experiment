## Stage 1 : build with maven builder image
FROM registry.access.redhat.com/ubi8/nodejs-14 AS build
RUN npm install --global yarn && npm cache clean --force;
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;
COPY public ./public
COPY src ./src
RUN yarn build && yarn cache clean;

## Stage 2 : create the docker final image
FROM registry.access.redhat.com/ubi8/nginx-118
ENV LANG=en_US.utf8

COPY nginx/nginx.conf "${NGINX_CONF_PATH}"
COPY --from=build /opt/app-root/src/build/ /var/www

EXPOSE 8080/tcp

CMD nginx -g "daemon off;"

