FROM alpine

LABEL org.opencontainers.image.source=https://github.com/nicolaschan/minecraft-backup

RUN apk add --no-cache bash coreutils xxd restic util-linux openssh

WORKDIR /code
COPY ./backup.sh .

ENTRYPOINT ["/code/backup.sh"]
