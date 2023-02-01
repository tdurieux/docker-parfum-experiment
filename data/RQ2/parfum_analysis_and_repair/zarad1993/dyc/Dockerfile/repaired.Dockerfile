FROM python:3-alpine
LABEL maintainer="Rodrigo Cristiano - rcristianofv@hotmail.com.br"
LABEL Version="1.0"

COPY . /code
WORKDIR /code
RUN set -e && \
    apk add --no-cache git && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --editable . && \
    rm -Rf *
