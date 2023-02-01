FROM python:slim

RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir 'google-cloud-pubsub<2'

ADD pubsub_init.py /pubsub_init.py

ENTRYPOINT python /pubsub_init.py
