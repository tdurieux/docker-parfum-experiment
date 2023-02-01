ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# install packages
RUN apk add --no-cache netatalk

# copy files
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]