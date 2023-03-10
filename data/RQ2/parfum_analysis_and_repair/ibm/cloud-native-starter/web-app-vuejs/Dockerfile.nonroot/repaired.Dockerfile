FROM node:8-alpine as BUILD

COPY src /usr/src/app/src
COPY public /usr/src/app/public
COPY package.json /usr/src/app/
COPY babel.config.js /usr/src/app/

WORKDIR /usr/src/app/
RUN yarn install && yarn cache clean;
RUN yarn build


FROM nginx:alpine

COPY nginx-8081.conf /etc/nginx/nginx.conf
COPY --from=BUILD /usr/src/app/dist /usr/share/nginx/html

RUN  mkdir -p /var/cache/nginx/client_temp && \
     chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx \
     && rm /etc/nginx/conf.d/default.conf

EXPOSE 8081
