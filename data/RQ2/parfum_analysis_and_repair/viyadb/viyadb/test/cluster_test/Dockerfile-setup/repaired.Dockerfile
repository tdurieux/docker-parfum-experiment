FROM python:3-slim

RUN pip3 install --no-cache-dir \
      kafka-python \
      requests