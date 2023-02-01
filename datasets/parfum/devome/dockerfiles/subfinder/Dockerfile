ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ENV INTERVAL=2h \
    UMASK=022 \
    PUID=1000 \
    PGID=100 \
    PS1="\u@\h:\w \$ "
COPY --from=nevinee/loop:latest / /
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache \
       python3 \
       py3-pip \
       unzip \
       unrar \
       su-exec \
       tini \
       libxml2 \
       libxslt \
    && apk add --update --no-cache --virtual .build \
       build-base \
       python3-dev \
       musl-dev \
       libxml2-dev \
       libxslt-dev \
       libffi-dev \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && pip install subfinder \
    && apk del --purge --no-cache .build \
    && rm -rf \
       /tmp/* \
       /root/.cache \
       /var/cache/apk/*
VOLUME ["/config", "/media"]
ENTRYPOINT ["tini", "entrypoint.sh"]
