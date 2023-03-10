FROM python:3.8-slim

COPY webserver/requirements.txt webserver/requirements.txt
RUN pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir -r webserver/requirements.txt

USER www-data

COPY --chown=www-data:www-data webserver /app/webserver

WORKDIR /app

ENV MODEL_DIRECTORY /mnt/models

ENTRYPOINT ["gunicorn", "--workers", "4", "--timeout", "180", "--bind", ":3000", "webserver.wsgi:app", "--capture-output", "--log-file", "-", "--access-logfile", "-"]
