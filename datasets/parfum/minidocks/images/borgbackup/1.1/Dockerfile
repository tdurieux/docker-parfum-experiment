FROM minidocks/python:3.6
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk add --update borgbackup \
    && rm -rf /var/cache/apk/* $PIP_CACHE_DIR/* && pyclean

COPY rootfs /

CMD [ "borg" ]
