FROM python:3.6-alpine
RUN apk add --no-cache curl git build-base
RUN apk add --no-cache libffi-dev openssl-dev
RUN pip install --no-cache-dir twine
