FROM postgres:11-alpine

# Install dependencies
RUN apk update && apk add --no-cache --virtual .build-deps && apk add --no-cache \
    bash make curl openssh git

# Install aws-cli
RUN apk -Uuv --no-cache add groff less python2 python3 py-pip && pip install --no-cache-dir awscli
# Cleanup
RUN rm /var/cache/apk/*


VOLUME ["/data/backups"]

ENV BACKUP_DIR /data/backups

ADD . /backup

ENTRYPOINT ["/backup/entrypoint.sh"]

CMD crond -f -l 2
