FROM python:3.8-alpine

RUN apk update \
    && apk add --no-cache --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache bash \
    && apk add --no-cache postgresql \
    && apk add --no-cache postgresql-dev \
    && pip install --no-cache-dir psycopg2 \
    && apk add --no-cache jpeg-dev zlib-dev libjpeg \
    && pip install --no-cache-dir Pillow \
    && apk del build-deps

WORKDIR /code/
COPY . /code/
WORKDIR /code/

RUN pip install --no-cache-dir -r /code/test/example/requirements.txt

RUN apk add --no-cache postgresql-libs

ENTRYPOINT ["/code/docker-entrypoint.sh"]
