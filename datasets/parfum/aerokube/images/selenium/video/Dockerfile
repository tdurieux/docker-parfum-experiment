FROM alpine:3.12

RUN apk add -U alpine-sdk && adduser -g "" -D -G abuild selenoid
USER selenoid
RUN git clone git://git.alpinelinux.org/aports /home/selenoid/aports
ADD APKBUILD /home/selenoid/aports/community/ffmpeg/
RUN cd /home/selenoid/aports/community/ffmpeg/ && \
    abuild checksum && \
    abuild unpack && \
    abuild deps && \
    abuild build
USER root

FROM alpine:3.12

RUN apk add -U x264-libs sdl2 libxcb libbz2 xset pulseaudio-utils && \
    rm -rf /var/cache/apk/*
COPY --from=0 /home/selenoid/aports/community/ffmpeg/src/ffmpeg-4.3/ffmpeg /usr/bin/ffmpeg

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
