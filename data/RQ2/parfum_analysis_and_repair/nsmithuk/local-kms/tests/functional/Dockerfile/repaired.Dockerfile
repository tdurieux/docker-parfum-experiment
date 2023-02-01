FROM python:3-slim

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirments.txt
