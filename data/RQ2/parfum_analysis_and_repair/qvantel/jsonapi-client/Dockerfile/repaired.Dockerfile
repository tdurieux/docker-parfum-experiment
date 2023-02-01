FROM python:3.6.1-alpine
MAINTAINER Tuomas Airaksinen <tuomas.airaksinen@qvantel.com>
ENV PYTHONUNBUFFERED 1
RUN apk update && apk upgrade && apk add --no-cache gcc python3-dev musl-dev make libffi-dev
RUN pip install --no-cache-dir -U pip setuptools
RUN adduser -D web
RUN mkdir /jsonapi-client
WORKDIR /jsonapi-client
ADD requirements.txt /jsonapi-client
RUN pip install --no-cache-dir -r requirements.txt
ADD . /jsonapi-client
RUN pip install --no-cache-dir -e .
RUN apk del gcc musl-dev make
CMD pytest tests/