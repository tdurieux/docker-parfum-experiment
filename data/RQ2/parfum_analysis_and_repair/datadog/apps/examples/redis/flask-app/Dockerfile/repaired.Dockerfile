FROM python:3.10-slim-buster

ADD . /flask-app
WORKDIR /flask-app

RUN pip install --no-cache-dir -r requirements.txt

