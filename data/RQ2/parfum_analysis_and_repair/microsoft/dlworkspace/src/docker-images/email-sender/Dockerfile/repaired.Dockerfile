FROM python:3.7

RUN pip3 install --no-cache-dir pyyaml pika

COPY *.py /email-sender/
