FROM alpine:3.16
RUN apk update && apk add --no-cache alsa-utils alsa-utils-doc alsa-lib alsaconf alsa-ucm-conf bash ffmpeg
RUN addgroup root audio
COPY asound.conf /etc/asound.conf
COPY record.sh /record.sh
ARG VERSION
ENV VERSION $VERSION
ENTRYPOINT ["/record.sh"]
CMD [""]
