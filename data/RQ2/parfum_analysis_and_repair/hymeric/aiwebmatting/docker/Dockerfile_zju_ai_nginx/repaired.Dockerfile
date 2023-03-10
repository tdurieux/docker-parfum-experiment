FROM nginx:stable

WORKDIR /usr/share/nginx/html

COPY docker/nginx.conf ./nginx.conf
COPY web/ .

RUN mv ./nginx.conf /etc/nginx/conf.d/default.conf && \
 rm -f README.md