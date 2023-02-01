ARG CRAFT_IMAGE_TAG=8.0
FROM craftcms/cli:$CRAFT_IMAGE_TAG
LABEL org.opencontainers.image.source=https://github.com/fortrabbit/craft-copy

USER root

COPY ./entrypoint.sh /

RUN apk add --no-cache gzip openssh rsync bash socat su-exec git mysql-client &&\
    mkdir -p /home/www-data/.ssh &&\
    chown www-data:www-data /home/www-data/.ssh/ &&\
    touch /home/www-data/.ssh/config &&\
    echo "Host *.frbit.com" >> /home/www-data/.ssh/config &&\
    echo "    StrictHostKeyChecking no" >> /home/www-data/.ssh/config  &&\
    chmod +x /entrypoint.sh &&\
    git config --system --add safe.directory /app

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./craft", "help"]
