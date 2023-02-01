FROM python:3.9-alpine

WORKDIR /

COPY requirements-freeze.txt /

RUN pip install --no-cache-dir -r requirements-freeze.txt

