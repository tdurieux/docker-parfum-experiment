FROM enspirit/webspicy:latest

ENTRYPOINT []
COPY --chown=app:app lib/webspicy/web/inferer/config.ru /home/app/config.ru

USER app

CMD rackup -o 0.0.0.0 -p 9292