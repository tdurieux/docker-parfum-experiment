FROM jrottenberg/ffmpeg:4.0-alpine

RUN apk add --no-cache inotify-tools bash

VOLUME ["/data"]

COPY watch_and_snapshot.sh /watch_and_snapshot.sh

RUN chmod +x /watch_and_snapshot.sh

ENTRYPOINT [ "/watch_and_snapshot.sh" ]