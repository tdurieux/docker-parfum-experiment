FROM nginx
COPY ./src/tests/ratelimit/nginx.conf /etc/nginx/nginx.conf