FROM alpine:3.5
MAINTAINER Stratio <front@stratio.com>

ARG VERSION
ARG COMMITID

RUN apk update && \
    apk add --no-cache nginx && \
    adduser -D -u 1000 -g 'www' www && \
    mkdir /usr/share/www && chown -R www:www /usr/share/www && \
    chown -R www:www /var/lib/nginx && \
    echo  ${COMMITD} > egeo-starter-${VERSION}.info

# Copy the artifacts
ADD dist /usr/share/www
COPY docker/docker_entrypoint /docker_entrypoint
COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /docker_entrypoint

EXPOSE 80

ENTRYPOINT ["/docker_entrypoint"]

# Command as default
CMD ["/bin/sh"]
