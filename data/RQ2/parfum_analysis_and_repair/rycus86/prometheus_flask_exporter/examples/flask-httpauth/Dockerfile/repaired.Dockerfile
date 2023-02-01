FROM python:3.8-alpine

RUN apk add --no-cache curl \
  && pip install --no-cache-dir flask Flask-HTTPAuth prometheus_client

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ADD examples/flask-httpauth /var/flask
WORKDIR /var/flask

CMD python /var/flask/httpauth_example.py
