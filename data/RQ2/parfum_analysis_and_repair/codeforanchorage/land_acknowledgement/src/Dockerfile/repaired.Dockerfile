FROM python:3.8.3-alpine3.12
WORKDIR /usr/src/
COPY requirements.txt /usr/src/
RUN apk add --no-cache python3-dev && \
    apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    pip3 install --no-cache-dir -r requirements.txt
