ARG VERSION
FROM selenoid/dev_yandex:$VERSION

COPY yandexdriver /usr/bin/
COPY entrypoint.sh /

RUN chmod +x /usr/bin/yandexdriver
USER selenium

EXPOSE 4444
ENTRYPOINT ["/entrypoint.sh"]
