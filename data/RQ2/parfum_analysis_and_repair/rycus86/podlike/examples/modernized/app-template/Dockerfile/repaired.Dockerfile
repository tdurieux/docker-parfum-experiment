FROM python:2.7-alpine

ADD requirements.txt /tmp/

RUN pip install --no-cache-dir -r /tmp/requirements.txt
