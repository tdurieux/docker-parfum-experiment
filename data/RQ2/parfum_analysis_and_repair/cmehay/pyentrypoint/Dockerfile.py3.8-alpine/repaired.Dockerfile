FROM python:3.8-alpine

ENV POETRY_VIRTUALENVS_CREATE=false

ADD . /usr/local/src/

RUN cd /usr/local/src/ && \
    apk add --no-cache gcc && \
    pip install --no-cache-dir --upgrade pip poetry && \
    poetry install --no-dev

ONBUILD ADD entrypoint-config.yml .

ENTRYPOINT ["pyentrypoint"]
