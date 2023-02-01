FROM minidocks/base
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add rclone && clean

ENV RCLONE_CONFIG=/etc/rclone/rclone.conf

COPY rootfs /
