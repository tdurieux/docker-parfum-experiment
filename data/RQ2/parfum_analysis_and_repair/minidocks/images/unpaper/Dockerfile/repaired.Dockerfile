FROM minidocks/ffmpeg
LABEL maintainer="Martin Hasoň <martin.hason@gmail.com>"

RUN apk --update --no-cache add unpaper && clean

COPY rootfs /

CMD [ "unpaper" ]

