FROM python:3.8-alpine

RUN apk add --no-cache curl && pip install --no-cache-dir flask prometheus_client

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ADD examples/reload/reload_example.py /var/flask/example.py
WORKDIR /var/flask

ENV DEBUG_METRICS 1

CMD python /var/flask/example.py
