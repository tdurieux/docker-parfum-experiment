# build environment
FROM node:16.13.0 as build
WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn install && yarn cache clean;
COPY . /app
RUN yarn run build

# production environment
FROM nginx:stable-alpine

RUN apk add --update --no-cache curl jq

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 7000;/' /etc/nginx/conf.d/default.conf
EXPOSE 7000
# comment user directive as master process is run as user in OpenShift anyhow
COPY nginx/nginx.conf /etc/nginx
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
RUN addgroup nginx root

COPY --from=build /app/build /usr/share/nginx/html
COPY docker-entrypoint.sh /var/cache/nginx
COPY generate_config_js.sh /var/cache/nginx
# permissions
RUN chmod +rwx /var/cache/nginx/docker-entrypoint.sh
RUN chmod +rwx /var/cache/nginx/generate_config_js.sh
RUN chmod -R 777 /usr/share/nginx/html

RUN dos2unix /var/cache/nginx/docker-entrypoint.sh
RUN dos2unix /var/cache/nginx/generate_config_js.sh
USER nginx
ENTRYPOINT ["/var/cache/nginx/docker-entrypoint.sh"]