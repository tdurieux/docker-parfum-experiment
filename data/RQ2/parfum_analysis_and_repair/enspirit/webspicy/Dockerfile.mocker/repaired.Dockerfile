FROM enspirit/webspicy:latest

ENTRYPOINT []
COPY lib/webspicy/web/mocker/config.ru /home/app/config.ru
CMD rackup