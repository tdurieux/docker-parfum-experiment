FROM xcgd/nginx-vts:stable

RUN mkdir /run/nginx && chown -R 65534:65534 /run /var/cache /etc/nginx

ADD docker/base/base.inc /etc/nginx/conf.d/base.inc
ADD docker/base/nginx.conf /etc/nginx/nginx.conf
ADD docker/base/metrics.conf /etc/nginx/conf.d/metrics.conf
ADD docker/prod/site.conf.template /etc/nginx/conf.d/site.conf.template

# static mediawiki files
ADD apple-touch-icon.png /usr/wikia/slot1/current/src/apple-touch-icon.png

ADD skins /usr/wikia/slot1/current/src/skins
ADD resources /usr/wikia/slot1/current/src/resources
ADD extensions /usr/wikia/slot1/current/src/extensions

USER 65534

# default read timeout, will be different for tasks
ENV FASTCGI_READ_TIMEOUT 180s

# envsubst is recommended by the creators of the nginx docker image
CMD envsubst '${FASTCGI_READ_TIMEOUT}' < /etc/nginx/conf.d/site.conf.template > /etc/nginx/conf.d/default.conf && nginx -c /etc/nginx/nginx.conf -g "daemon off;"