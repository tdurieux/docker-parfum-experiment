FROM minidocks/openssh
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add rsync && clean

COPY rootfs /
