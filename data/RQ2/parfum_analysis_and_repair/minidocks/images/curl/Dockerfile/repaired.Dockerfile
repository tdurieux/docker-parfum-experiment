FROM minidocks/base
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add curl jq pup libxml2-utils && clean

COPY rootfs /
