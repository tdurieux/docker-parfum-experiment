FROM python:2.7
MAINTAINER Eugene Zilman <ezilman@gmail.com>

RUN pip install --no-cache-dir gunicorn

COPY gunicorn_conf.py /

ENTRYPOINT ["/usr/local/bin/gunicorn", "--config", "/gunicorn_conf.py"]


