FROM node:14 AS build

COPY ./mwdb/web /app
COPY ./docker/plugins /plugins

RUN cd /app \
    && npm install --unsafe-perm . $(find /plugins -name 'package.json' -printf "%h\n" | sort -u) \
    && CI=true npm run build \
    && npm cache clean --force

FROM nginx:stable

ENV PROXY_BACKEND_URL http://mwdb.:8080

COPY docker/nginx.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/start-web.sh /start-web.sh
COPY --from=build /app/build /usr/share/nginx/html

# Give +r to everything in /usr/share/nginx/html and +x for directories
RUN chmod u=rX,go= -R /usr/share/nginx/html

# By default everything is owned by root - change owner to nginx
RUN chown nginx:nginx -R /usr/share/nginx/html

CMD ["/bin/sh", "/start-web.sh"]