FROM python:alpine

# hadolint ignore=DL3013
RUN pip3 install --no-cache-dir -q pika prometheus_client

ENV ADDRESS rabbitmq
ENV USERNAME istio

COPY rabbitmq/client.py /client.py
COPY prom_client.py /prom_client.py

CMD ["python3", "-u", "/client.py"]