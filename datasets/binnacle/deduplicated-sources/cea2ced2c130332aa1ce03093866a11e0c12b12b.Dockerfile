FROM alpine:latest
ENV UUID=""
ENV PORT 8001

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /usr/bin/

RUN set -ex && \
    apk --no-cache add ca-certificates nginx && \
    mkdir /var/log/v2ray/ && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray && \
    mkdir /run/nginx
COPY default.conf /etc/nginx/conf.d/default.conf
ENV PATH /usr/bin/v2ray:$PATH

EXPOSE $PORT
ENTRYPOINT ["entrypoint.sh"]
