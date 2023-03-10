FROM library/nginx:1.21.1-alpine
RUN mkdir -p /var/cache/nginx /var/cache/nginx/feeds
RUN apk update && apk upgrade && apk add --no-cache bash
ENV NGINX_LOG_DIR /var/log/nginx
# this is to avoid having these logs redirected to stdout/stderr
RUN rm $NGINX_LOG_DIR/access.log $NGINX_LOG_DIR/error.log
RUN touch $NGINX_LOG_DIR/access.log $NGINX_LOG_DIR/error.log
RUN chown 33:33 $NGINX_LOG_DIR/access.log $NGINX_LOG_DIR/error.log
VOLUME $NGINX_LOG_DIR