FROM python:3.9-slim-buster

# RUN apt install gcc libpq (no longer needed bc we use psycopg2-binary)

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN mkdir -p /src
COPY src/ /src/
RUN pip install --no-cache-dir -e /src
COPY tests/ /tests/

WORKDIR /src
