FROM python:2-alpine

RUN pip install --no-cache-dir requests \
  && pip install --no-cache-dir cloudflare
