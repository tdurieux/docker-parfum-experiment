FROM python:3.8-alpine

RUN apk add --no-cache curl && pip install flask connexion pydantic prometheus_client

ADD . /tmp/latest
RUN pip install -e /tmp/latest --upgrade

ADD examples/connexion-pydantic /var/flask
WORKDIR /var/flask

CMD python /var/flask/main.py
