FROM python:2.7-alpine

RUN apk --no-cache add libmagic

RUN pip install --no-cache-dir panoptes-client
