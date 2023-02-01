FROM python:3.7.12-alpine3.14

WORKDIR /app
EXPOSE 3334
RUN apk -U --no-cache add bash vim ffmpeg postgresql-libs git && \
    apk add --no-cache --virtual .build-deps g++ musl-dev postgresql-dev zlib-dev jpeg-dev libffi-dev
RUN pip install --no-cache-dir --upgrade pip

ADD requirements.txt .
RUN CRYPTOGRAPHY_DONT_BUILD_RUST=1 pip --no-cache-dir install -r requirements.txt

RUN apk --purge del .build-deps
