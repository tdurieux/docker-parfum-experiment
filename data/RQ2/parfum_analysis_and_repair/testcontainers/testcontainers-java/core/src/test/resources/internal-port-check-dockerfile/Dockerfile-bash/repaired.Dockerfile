FROM nginx:1.17-alpine

RUN apk add --no-cache bash

# Make sure the /proc/net/tcp* check fails in this container
RUN rm /usr/bin/awk

# Make sure the nc check fails in this container
RUN rm /usr/bin/nc

ADD nginx.conf /etc/nginx/conf.d/default.conf
