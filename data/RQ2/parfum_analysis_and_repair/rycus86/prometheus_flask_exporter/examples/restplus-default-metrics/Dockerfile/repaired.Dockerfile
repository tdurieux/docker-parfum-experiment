FROM python:3.8-alpine

RUN apk add --no-cache curl && pip install --no-cache-dir flask flask-restx prometheus_client

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ADD examples/restplus-default-metrics/server.py /var/flask/example.py
WORKDIR /var/flask

CMD python /var/flask/example.py
