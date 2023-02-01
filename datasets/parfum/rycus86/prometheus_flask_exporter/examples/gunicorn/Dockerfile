FROM python:3.8-alpine

ADD examples/gunicorn/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

ADD . /tmp/latest
RUN pip install -e /tmp/latest --upgrade

ADD examples/gunicorn/server.py examples/gunicorn/config.py /var/flask/
WORKDIR /var/flask

ENV PROMETHEUS_MULTIPROC_DIR /tmp
ENV prometheus_multiproc_dir /tmp
ENV METRICS_PORT 9200

CMD gunicorn -c config.py -w 4 -b 0.0.0.0:4000 server:app
