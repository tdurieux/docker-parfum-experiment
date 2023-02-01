FROM python:3.9-alpine

ENV PYTHONUNBUFFERED=1 \
    PRAGMA_VERSION=py3.9 \
    DEBUG=0

WORKDIR /code

COPY requirements/ /code/requirements/

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        python3-dev \
    && pip install --no-cache-dir pip setuptools wheel --upgrade \
    && pip install --no-cache-dir -r requirements/base.txt \
    && pip install --no-cache-dir -r requirements/test.txt \
    && pip install --no-cache-dir -r requirements/ci.txt \
    && apk del .build-deps \
    && addgroup -S kuchulu \
    && adduser \
        --disabled-password \
        --gecos "" \
        --ingroup kuchulu \
        --no-create-home \
        -s /bin/false \
        kuchulu

ARG VERSION=1
RUN echo "Vesion: ${VERSION}"

COPY . /code/

RUN chown kuchulu:kuchulu -R /code

USER kuchulu
