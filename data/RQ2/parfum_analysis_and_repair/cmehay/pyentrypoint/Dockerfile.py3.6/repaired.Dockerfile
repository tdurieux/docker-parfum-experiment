FROM python:3.6

ENV POETRY_VIRTUALENVS_CREATE=false

ADD . /usr/local/src/

RUN cd /usr/local/src/ && \
    pip install --no-cache-dir --upgrade pip poetry && \
    poetry install --no-dev

ONBUILD ADD entrypoint-config.yml .

ENTRYPOINT ["pyentrypoint"]
