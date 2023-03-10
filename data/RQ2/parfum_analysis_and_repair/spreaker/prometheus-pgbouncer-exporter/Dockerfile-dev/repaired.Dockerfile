FROM python:3.6-alpine

# Install dependencies
COPY . /prometheus-pgbouncer-exporter
RUN apk add --update --no-cache postgresql-dev gcc musl-dev && \
     pip install --no-cache-dir -r /prometheus-pgbouncer-exporter/requirements.txt

WORKDIR /prometheus-pgbouncer-exporter
RUN python setup.py install
