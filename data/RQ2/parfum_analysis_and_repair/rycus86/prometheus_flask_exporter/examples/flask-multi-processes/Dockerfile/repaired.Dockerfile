FROM python:3.8-alpine

RUN apk add --no-cache curl \
  && pip install --no-cache-dir flask prometheus_client

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ADD examples/flask-multi-processes /var/flask
WORKDIR /var/flask

ENV PROMETHEUS_MULTIPROC_DIR /tmp
CMD python /var/flask/processes_example.py
