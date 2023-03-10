FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

RUN apk update \
  && apk add --no-cache --virtual build-dependencies \
     build-base

WORKDIR /app

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/doc.txt

COPY ./compose/local/docs/start /start
RUN sed -i 's/\r//' /start
RUN chmod +x /start
