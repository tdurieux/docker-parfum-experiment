FROM python:3.4-alpine
USER root

ADD . /code
WORKDIR /code

RUN pip install --no-cache-dir -r requirements.txt
