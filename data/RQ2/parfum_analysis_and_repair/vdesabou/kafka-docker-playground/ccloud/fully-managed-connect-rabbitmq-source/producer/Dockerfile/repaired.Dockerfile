FROM python:3

ADD producer.py /

RUN pip install --no-cache-dir pika

CMD sleep infinity