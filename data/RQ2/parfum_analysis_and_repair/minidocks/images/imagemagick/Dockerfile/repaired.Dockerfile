FROM minidocks/ghostscript AS latest
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

ARG package=imagemagick

RUN apk --update --no-cache add curl $package && clean

COPY rootfs /

CMD [ "convert" ]
