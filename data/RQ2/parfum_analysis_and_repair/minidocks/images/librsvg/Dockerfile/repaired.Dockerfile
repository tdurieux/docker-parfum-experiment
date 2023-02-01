FROM minidocks/poppler
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add librsvg && clean

COPY rootfs /

CMD [ "rsvg-convert" ]
