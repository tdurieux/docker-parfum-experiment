FROM nginx
ARG NGINX_CONFIG
ENV NGINX_CONFIG=${NGINX_CONFIG:-nginx-ssl.conf}
COPY --from=bot-fe /usr/src/app/release /usr/share/nginx/html

COPY ./Docker/$NGINX_CONFIG /etc/nginx/nginx.conf