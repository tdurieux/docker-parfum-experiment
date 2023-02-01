FROM jrottenberg/ffmpeg:4.1-alpine

COPY plexus /usr/bin/plexus

RUN chmod u+x /usr/bin/plexus

RUN apk update && \
    apk add --no-cache bash curl rsync unzip

RUN curl -f https://rclone.org/install.sh | bash

WORKDIR /root/.config/plexus

ENTRYPOINT [ "plexus" ]
