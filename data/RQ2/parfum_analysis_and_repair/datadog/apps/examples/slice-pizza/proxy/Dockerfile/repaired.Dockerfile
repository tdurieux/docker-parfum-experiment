FROM python:3.10-slim-buster

ADD . /proxy
WORKDIR /proxy

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

