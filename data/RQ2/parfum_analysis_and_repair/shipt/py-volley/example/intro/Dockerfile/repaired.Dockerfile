FROM python:3.9.4 as base

RUN pip3 install --no-cache-dir py-volley

COPY . /app/
