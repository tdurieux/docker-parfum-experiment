FROM python:3.7-slim

ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir graphql-schema-diff==1.0.2

WORKDIR /app

ENTRYPOINT ["schemadiff"]
