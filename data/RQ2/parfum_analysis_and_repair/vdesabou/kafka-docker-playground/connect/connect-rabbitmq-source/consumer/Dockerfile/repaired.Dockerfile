FROM python:3

ADD consumer.py /

RUN pip install --no-cache-dir pika

CMD sleep infinity