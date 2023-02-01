# Base Image
FROM python:3.8-alpine
EXPOSE 8001
# RUN apk add --update bash curl git && rm -rf /var/cache/apk/*

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apk add --no-cache build-base
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache openssl
RUN pip install --no-cache-dir -r requirements.txt
CMD python3 run_server.py start