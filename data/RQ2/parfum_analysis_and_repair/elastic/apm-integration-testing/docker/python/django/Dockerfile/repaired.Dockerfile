FROM python:3.7

RUN pip install --no-cache-dir -q -U Django==2.1.5

RUN mkdir -p /app
COPY testapp /app/testapp

WORKDIR /app
