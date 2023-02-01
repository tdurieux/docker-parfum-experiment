FROM python:2.7-slim

WORKDIR /code
COPY . ./
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir -r requirements-dev.txt
