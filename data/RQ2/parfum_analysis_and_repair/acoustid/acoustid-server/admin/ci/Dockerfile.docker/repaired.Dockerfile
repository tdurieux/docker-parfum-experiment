FROM docker:stable

RUN apk add --no-cache py-pip python-dev libffi-dev openssl-dev gcc libc-dev make bash
RUN pip install --no-cache-dir docker-compose
