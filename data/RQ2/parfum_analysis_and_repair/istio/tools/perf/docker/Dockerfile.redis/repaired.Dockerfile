FROM python:alpine

# hadolint ignore=DL3013
RUN pip3 install --no-cache-dir -q redis prometheus_client

ENV PORT 6379
ENV ADDRESS redis-master

ENV SLAVE_PORT 6379
ENV SLAVE_ADDRESS redis-slave

COPY redis/client.py /client.py
COPY prom_client.py /prom_client.py

CMD ["python3", "-u", "/client.py"]