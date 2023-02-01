FROM python:3.8-slim

RUN pip install --no-cache-dir dnslib

COPY dns_server.py /dns_server.py

ENV PYTHONUNBUFFERED=1
