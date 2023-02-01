FROM python:3.6.12-stretch

WORKDIR /app

ADD . /app

RUN pip install --no-cache-dir -r requirements.txt

USER 10017

ENTRYPOINT ./entrypoint.sh
